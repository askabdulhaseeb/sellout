import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/chat_provider.dart';

 void showContactsBottomSheet(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
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
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  Contact? _selectedContact;
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  void _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _error = true);
      return;
    }

    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          setState(() => _error = true);
          return [];
        },
      );

      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _allContacts.where((c) {
        return c.displayName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    return parts.length == 1
        ? parts[0][0].toUpperCase()
        : (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<File?> _exportContactAsVcf(Contact contact) async {
    try {
      final vcf = contact.toVCard();
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${contact.displayName}.vcf');
      await file.writeAsString(vcf);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (_error) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Cannot access contacts."),
      );
    }

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextFormField(
                controller: _searchController,
                onChanged: _filterContacts,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: Theme.of(context).colorScheme.primary,
                ),
                hint: 'search'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedContact == contact;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        _getInitials(contact.displayName),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    title: Text(contact.displayName, style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Text(
                      contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : 'no_phone_number'.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomElevatedButton(
                title: 'send'.tr(),
                isLoading: chatProvider.isLoading,
                onTap: () async {
                  final contact = _selectedContact;
                  if (contact != null && contact.phones.isNotEmpty) {
                    final file = await _exportContactAsVcf(contact);
                    if (file != null) {
                      final attachment = PickedAttachment(
                        type: AttachmentType.contacts,
                        file: file,
                      );
                      chatProvider.addAttachment(attachment);
                      chatProvider.sendMessage(context);
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
