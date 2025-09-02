import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsBottomSheetLogic {
  List<Contact> allContacts = <Contact>[];
  List<Contact> filteredContacts = <Contact>[];
  bool loading = true;
  bool error = false;

  final Map<String, int> letterIndexMap = <String, int>{};
  String activeLetter = '';
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late void Function(void Function()) setState;

  void init(BuildContext context, void Function(void Function()) setStateFn) {
    setState = setStateFn;
    scrollController.addListener(_updateActiveLetterOnScroll);
    _fetchContacts();
  }

  void dispose() {
    scrollController.removeListener(_updateActiveLetterOnScroll);
    scrollController.dispose();
  }

  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => error = true);
      return;
    }

    try {
      final List<Contact> contacts = await FlutterContacts.getContacts(
        withAccounts: true,
        withThumbnail: true,
        withProperties: true,
        withPhoto: true,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          setState(() => error = true);
          return <Contact>[];
        },
      );

      contacts.sort(
          (Contact a, Contact b) => a.displayName.compareTo(b.displayName));

      letterIndexMap.clear();
      for (int i = 0; i < contacts.length; i++) {
        final String firstLetter = contacts[i].displayName.isEmpty
            ? '#'
            : contacts[i].displayName[0].toUpperCase();
        letterIndexMap.putIfAbsent(firstLetter, () => i);
      }

      setState(() {
        allContacts = contacts;
        filteredContacts = contacts;
        loading = false;
        activeLetter = contacts.isNotEmpty
            ? contacts.first.displayName[0].toUpperCase()
            : '';
      });
    } catch (_) {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  void filterContacts(String query) {
    setState(() {
      filteredContacts = allContacts
          .where((Contact c) =>
              c.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void scrollToLetter(String letter) {
    if (letterIndexMap.containsKey(letter)) {
      final int index = letterIndexMap[letter]!;
      scrollController.animateTo(
        index * 72.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      setState(() => activeLetter = letter);
    }
  }

  void _updateActiveLetterOnScroll() {
    if (allContacts.isEmpty) return;
    final double offset = scrollController.offset;
    final int index = (offset / 72.0).floor().clamp(0, allContacts.length - 1);
    final String letter = allContacts[index].displayName.isEmpty
        ? '#'
        : allContacts[index].displayName[0].toUpperCase();

    if (letter != activeLetter) {
      setState(() => activeLetter = letter);
    }
  }
}
