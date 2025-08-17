import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../core/widgets/custom_memory_image.dart';
import '../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/send_message_provider.dart';

void showContactsBottomSheet(BuildContext context) async {
  showModalBottomSheet(
    showDragHandle: false,
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext context) {
      return _ContactsBottomSheet();
    },
  );
}

class _ContactsBottomSheet extends StatefulWidget {
  @override
  State<_ContactsBottomSheet> createState() => _ContactsBottomSheetState();
}

class _ContactsBottomSheetState extends State<_ContactsBottomSheet> {
  List<Contact> _allContacts = <Contact>[];
  List<Contact> _filteredContacts = <Contact>[];
  Contact? _selectedContact;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _loading = true;
  bool _error = false;

  final Map<String, int> _letterIndexMap = <String, int>{};
  String _activeLetter = ''; // currently active letter

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveLetterOnScroll);
    _fetchContacts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveLetterOnScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _error = true);
      return;
    }

    try {
      final List<Contact> contacts = await FlutterContacts.getContacts(
              withProperties: true, withPhoto: true)
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          setState(() => _error = true);
          return <Contact>[];
        },
      );

      contacts.sort(
          (Contact a, Contact b) => a.displayName.compareTo(b.displayName));

      _letterIndexMap.clear();
      for (int i = 0; i < contacts.length; i++) {
        final String firstLetter = contacts[i].displayName.isEmpty
            ? '#'
            : contacts[i].displayName[0].toUpperCase();
        if (!_letterIndexMap.containsKey(firstLetter)) {
          _letterIndexMap[firstLetter] = i;
        }
      }

      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _loading = false;
        _activeLetter = _allContacts.isNotEmpty
            ? _allContacts.first.displayName[0].toUpperCase()
            : '';
      });
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  void _scrollToLetter(String letter) {
    if (_letterIndexMap.containsKey(letter)) {
      final int index = _letterIndexMap[letter]!;
      _scrollController.animateTo(
        index * 72.0, // approximate height of each ListTile
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      setState(() => _activeLetter = letter);
    }
  }

  void _updateActiveLetterOnScroll() {
    if (_allContacts.isEmpty) return;

    final double offset = _scrollController.offset;
    final int index = (offset / 72.0).floor().clamp(0, _allContacts.length - 1);
    final String letter = _allContacts[index].displayName.isEmpty
        ? '#'
        : _allContacts[index].displayName[0].toUpperCase();

    if (letter != _activeLetter) {
      setState(() => _activeLetter = letter);
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _allContacts.where((Contact c) {
        return c.displayName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<File?> _exportContactAsVcf(Contact contact) async {
    try {
      final String vcf = contact.toVCard();
      final Directory directory = await getTemporaryDirectory();
      final File file = File('${directory.path}/${contact.displayName}.vcf');
      await file.writeAsString(vcf);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    if (_error) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Cannot access contacts.'),
      );
    }

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const AppBarTitle(titleKey: 'choose_contact'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextFormField(
              controller: _searchController,
              onChanged: _filterContacts,
              hint: 'search'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                // Contacts List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _filteredContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Contact contact = _filteredContacts[index];
                      final bool isSelected = _selectedContact == contact;

                      return ListTile(
                        leading: CustomMemoryImage(
                          displayName: contact.displayName,
                          photo: contact.photo,
                        ),
                        title: Text(contact.displayName,
                            style: Theme.of(context).textTheme.bodyLarge),
                        subtitle: Text(
                          contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : 'no_phone_number'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedContact = contact;
                          });
                        },
                      );
                    },
                  ),
                ),

                // Alphabet Slider
                SizedBox(
                  width: 24,
                  child: AlphabetSlider(
                    activeLetter: _activeLetter,
                    onLetterTap: _scrollToLetter,
                    availableLetters: _letterIndexMap.keys.toSet(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomElevatedButton(
              title: 'send'.tr(),
              isLoading: msgPro.isLoading,
              bgColor: _selectedContact != null &&
                      _selectedContact!.phones.isNotEmpty
                  ? AppTheme.primaryColor
                  : Theme.of(context).disabledColor,
              onTap: () async {
                final Contact? contact = _selectedContact;
                if (contact != null && contact.phones.isNotEmpty) {
                  final File? file = await _exportContactAsVcf(contact);
                  if (file != null) {
                    final PickedAttachment attachment = PickedAttachment(
                      type: AttachmentType.contacts,
                      file: file,
                    );
                    msgPro.addContact(attachment);
                    await msgPro.sendContact(context);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AlphabetSlider extends StatelessWidget {
  const AlphabetSlider({
    required this.onLetterTap,
    required this.availableLetters,
    required this.activeLetter,
    super.key,
  });

  final void Function(String letter) onLetterTap;
  final Set<String> availableLetters;
  final String activeLetter; // currently active/tapped letter

  final List<String> _alphabet = const <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _alphabet.map((String letter) {
          final bool enabled = availableLetters.contains(letter);
          final bool isActive = letter == activeLetter;

          return GestureDetector(
            onTap: enabled ? () => onLetterTap(letter) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: isActive ? 18 : 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.bold,
                  color: enabled
                      ? (isActive
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.outline)
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
