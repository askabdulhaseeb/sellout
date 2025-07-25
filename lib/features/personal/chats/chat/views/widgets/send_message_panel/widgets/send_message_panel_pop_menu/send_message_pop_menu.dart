import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../send_message_panel_bottomsheets/send_message_camera_bottomsheet.dart';
import '../send_message_panel_bottomsheets/send_message_contacts_bottomsheet.dart';
import '../send_message_panel_bottomsheets/send_message_documents_bottomsheet.dart';
import '../send_message_panel_bottomsheets/media_type_selection_bottomsheet.dart';
import 'enum/send_message_pop_menu_enums.dart';

/// A button widget showing a popup menu to pick various attachments (camera, documents, contacts, etc.)
class AttachmentMenuButton extends StatelessWidget {
  const AttachmentMenuButton({super.key});

  /// Handles selection of attachment options
  Future<void> _handleAttachment(
      BuildContext context, SendMessagePopMenuOptions option) async {
    switch (option) {
      case SendMessagePopMenuOptions.camera:
        showCameraPickerBottomSheet(context);
        break;

      case SendMessagePopMenuOptions.mediaLibrary:
        showMediaBottomSheet(context);
        break;

      // case SendMessagePopMenuOptions.location:
      //   // TODO: Implement location picking logic
      //   break;

      case SendMessagePopMenuOptions.document:
        await pickDocument(context);
        break;

      case SendMessagePopMenuOptions.contacts:
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
        'option': SendMessagePopMenuOptions.camera,
        'icon': Icons.photo_camera_outlined,
        'title': 'photo_camera'.tr(),
      },
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.mediaLibrary,
        'icon': Icons.photo_library_outlined,
        'title': 'photo_video_library'.tr(),
      },
      // <String, dynamic>{
      //   'option': SendMessagePopMenuOptions.location,
      //   'icon': Icons.location_on_outlined,
      //   'title': 'location'.tr(),
      // },
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.document,
        'icon': Icons.insert_drive_file_outlined,
        'title': 'document'.tr(),
      },
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.contacts,
        'icon': Icons.contact_page_outlined,
        'title': 'contacts'.tr(),
      },
    ];

    return PopupMenuButton<SendMessagePopMenuOptions>(
      padding: const EdgeInsets.all(0),
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (SendMessagePopMenuOptions option) =>
          _handleAttachment(context, option),
      itemBuilder: (_) => menuItems.map((Map<String, dynamic> item) {
        return _buildMenuItem(
          context,
          option: item['option'] as SendMessagePopMenuOptions,
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          iconColor: iconColor,
        );
      }).toList(),
      child: Icon(Icons.add_circle_outline_outlined, color: iconColor),
    );
  }

  /// Builds a popup menu item widget
  PopupMenuItem<SendMessagePopMenuOptions> _buildMenuItem(
    BuildContext context, {
    required SendMessagePopMenuOptions option,
    required IconData icon,
    required String title,
    Color? iconColor,
  }) {
    return PopupMenuItem<SendMessagePopMenuOptions>(
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
