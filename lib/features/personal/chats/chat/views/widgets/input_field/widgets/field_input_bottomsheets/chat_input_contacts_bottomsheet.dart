import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


void showContactsBottomSheet(BuildContext context) async {
  // Request permission first
  if (!await FlutterContacts.requestPermission()) {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('permission_denied'.tr())),
    );
    return;
  }

  // Fetch contacts
  final List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
String getInitials(String name) {
  final List<String> parts = name.trim().split(' ');
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  } else {
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

  // Show bottom sheet
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return ListView.builder(
            controller: scrollController,
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              final Contact contact = contacts[index];
              return ListTile(
leading: CircleAvatar(
  backgroundColor: ColorScheme.of(context).secondary, // You can change the color as needed
  child: Text(
    getInitials(contact.displayName),
    style:  TextStyle(
      color: ColorScheme.of(context).onSecondary,
      fontWeight: FontWeight.bold,
    ),
  ),
),
                title: Text(contact.displayName),
                subtitle: contact.phones.isNotEmpty
                    ? Text(contact.phones.first.number)
                    : const Text('No phone number'),
              );
            },
          );
        },
      );
    },
  );
}
