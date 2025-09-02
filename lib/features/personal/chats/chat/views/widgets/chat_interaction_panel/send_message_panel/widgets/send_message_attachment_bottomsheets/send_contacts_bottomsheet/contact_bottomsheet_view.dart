import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../../core/widgets/custom_memory_image.dart';
import '../../../../../../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../../providers/send_message_provider.dart';
import 'alphabet_slider.dart';
import 'contact_bottomsheet_logic.dart';
import 'contact_export.dart';

class ContactsBottomSheetView extends StatefulWidget {
  @override
  State<ContactsBottomSheetView> createState() =>
      _ContactsBottomSheetViewState();
}

class _ContactsBottomSheetViewState extends State<ContactsBottomSheetView> {
  final ContactsBottomSheetLogic _logic = ContactsBottomSheetLogic();
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _logic.init(context, setState);
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    if (_logic.error) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('something_wrong'.tr()),
      );
    }

    if (_logic.loading) {
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
              controller: _logic.searchController,
              onChanged: _logic.filterContacts,
              hint: 'search'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _logic.scrollController,
                    itemCount: _logic.filteredContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Contact contact = _logic.filteredContacts[index];
                      final bool isSelected = _selectedContact == contact;

                      return ListTile(
                        leading: CustomMemoryImage(
                          displayName: contact.displayName,
                          photo: contact.photo,
                        ),
                        title: Text(
                          contact.displayName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                  : 'no_phone_number'.tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (contact.organizations.isNotEmpty)
                              Text(
                                contact.organizations.first.company,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                        onTap: () => setState(() => _selectedContact = contact),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: AlphabetSlider(
                    activeLetter: _logic.activeLetter,
                    onLetterTap: _logic.scrollToLetter,
                    availableLetters: _logic.letterIndexMap.keys.toSet(),
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
                if (_selectedContact != null &&
                    _selectedContact!.phones.isNotEmpty) {
                  final File? file =
                      await exportContactAsVcf(_selectedContact!);
                  if (file != null) {
                    msgPro.addContact(PickedAttachment(
                      type: AttachmentType.contacts,
                      file: file,
                    ));
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
