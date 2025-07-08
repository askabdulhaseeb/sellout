import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../field_input_bottomsheets/chat_input_camera_bottomsheet.dart';
import '../field_input_bottomsheets/chat_input_contacts_bottomsheet.dart';
import '../field_input_bottomsheets/chat_input_documents_bottomsheet.dart';
import '../field_input_bottomsheets/media_type_selection_bottomsheet.dart';
import 'enum/chat_pop_menu_enums.dart';

/// A button widget showing a popup menu to pick various attachments (camera, documents, contacts, etc.)
class AttachmentMenuButton extends StatelessWidget {
  const AttachmentMenuButton({super.key});

  /// Handles selection of attachment options
  Future<void> _handleAttachment(
      BuildContext context, ChatPopMenuOptions option) async {
    switch (option) {
      case ChatPopMenuOptions.camera:
        showCameraPickerBottomSheet(context);
        break;

      case ChatPopMenuOptions.mediaLibrary:
        showMediaBottomSheet(context);
        break;

      // case ChatPopMenuOptions.location:
      //   // TODO: Implement location picking logic
      //   break;

      case ChatPopMenuOptions.document:
        await pickDocument(context);
        break;

      case ChatPopMenuOptions.contacts:
        showContactsBottomSheet(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = Theme.of(context).iconTheme.color;
    // List of menu items with values, icons, and localized titles
    final List<Map<String, dynamic>> menuItems = <Map<String, dynamic>>[
      <String, dynamic>{
        'option': ChatPopMenuOptions.camera,
        'icon': Icons.photo_camera_outlined,
        'title': 'photo_camera'.tr(),
      },
      <String, dynamic>{
        'option': ChatPopMenuOptions.mediaLibrary,
        'icon': Icons.photo_library_outlined,
        'title': 'photo_video_library'.tr(),
      },
      // <String, dynamic>{
      //   'option': ChatPopMenuOptions.location,
      //   'icon': Icons.location_on_outlined,
      //   'title': 'location'.tr(),
      // },
      <String, dynamic>{
        'option': ChatPopMenuOptions.document,
        'icon': Icons.insert_drive_file_outlined,
        'title': 'document'.tr(),
      },
      <String, dynamic>{
        'option': ChatPopMenuOptions.contacts,
        'icon': Icons.contact_page_outlined,
        'title': 'contacts'.tr(),
      },
    ];

    return PopupMenuButton<ChatPopMenuOptions>(
      padding: const EdgeInsets.all(0),
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (ChatPopMenuOptions option) =>
          _handleAttachment(context, option),
      itemBuilder: (_) => menuItems.map((Map<String, dynamic> item) {
        return _buildMenuItem(
          context,
          option: item['option'] as ChatPopMenuOptions,
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          iconColor: iconColor,
        );
      }).toList(),
      child: Icon(Icons.add_circle_outline_outlined, color: iconColor),
    );
  }

  /// Builds a popup menu item widget
  PopupMenuItem<ChatPopMenuOptions> _buildMenuItem(
    BuildContext context, {
    required ChatPopMenuOptions option,
    required IconData icon,
    required String title,
    Color? iconColor,
  }) {
    return PopupMenuItem<ChatPopMenuOptions>(
      value: option,
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
