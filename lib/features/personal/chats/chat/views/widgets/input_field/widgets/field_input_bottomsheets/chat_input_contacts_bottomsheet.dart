import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/chat_provider.dart';


void showContactsBottomSheet(BuildContext context) async {
  if (!await FlutterContacts.requestPermission()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('permission_denied'.tr())),
    );
    return;
  }

  final List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

  String getInitials(String name) {
    final List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  final Set<Contact> selectedContacts = <Contact>{};

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
Future<File?> exportContactAsVcf(Contact contact) async {
  try {
    // Convert contact to vCard format
    final String vcf = contact.toVCard();

    // Get temporary directory
    final Directory directory = await getTemporaryDirectory();

    // Create file
    final File file = File('${directory.path}/${contact.displayName}.vcf');

    // Write vCard to file
    await file.writeAsString(vcf);

    return file;
  } catch (e) {
    print("Error exporting contact: $e");
    return null;
  }
}

          return Column(
            children: <Widget>[
              Expanded(
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.7,
                  maxChildSize: 0.95,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: contacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Contact contact = contacts[index];
                        final bool isSelected = selectedContacts.contains(contact);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ColorScheme.of(context).secondary,
                            child: Text(
                              getInitials(contact.displayName),
                              style: TextStyle(
                                color: ColorScheme.of(context).onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(contact.displayName),
                          subtitle: contact.phones.isNotEmpty
                              ? Text(contact.phones.first.number)
                              : const Text('No phone number'),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.teal)
                              : const Icon(Icons.radio_button_unchecked),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedContacts.remove(contact);
                              } else {
                                selectedContacts.add(contact);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: Text('send_selected'.tr()),
           onPressed: () async {
  final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
  for (final Contact contact in selectedContacts) {
    if (contact.phones.isNotEmpty) {
      final File? file = await exportContactAsVcf(contact);
      if (file != null) {
        final PickedAttachment attachment = PickedAttachment(
          type: AttachmentType.contacts,
          file: file,
        );
        chatProvider.addAttachment(attachment);
      }
    }
  }

  Navigator.pop(context);
},
    ),
              )
            ],
          );
        },
      );
    },
  );
}
