import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../send_message_attachment_bottomsheets/send_message_camera_bottomsheet.dart';
import '../send_message_attachment_bottomsheets/send_contacts_bottomsheet/send_message_contacts_bottomsheet.dart';
import '../send_message_attachment_bottomsheets/send_message_document_bottomsheet.dart';
import '../send_message_attachment_bottomsheets/media_type_selection_bottomsheet.dart';
import 'enum/send_message_pop_menu_enums.dart';

class SendMessageAttachmentMenuButton extends StatefulWidget {
  const SendMessageAttachmentMenuButton({super.key});

  @override
  State<SendMessageAttachmentMenuButton> createState() =>
      _SendMessageAttachmentMenuButtonState();
}

class _SendMessageAttachmentMenuButtonState
    extends State<SendMessageAttachmentMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // Rotate slightly by 15 degrees (pi/12 radians)
    _rotationAnimation = Tween<double>(begin: 0, end: 0.35) // ~15°
        .animate(CurvedAnimation(
            parent: _rotationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _handleAttachment(
      BuildContext context, SendMessagePopMenuOptions option) async {
    switch (option) {
      case SendMessagePopMenuOptions.camera:
        showCameraPickerBottomSheet(context);
        break;
      case SendMessagePopMenuOptions.mediaLibrary:
        showMediaBottomSheet(context);
        break;
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

    final List<Map<String, dynamic>> menuItems = <Map<String, dynamic>>[
      {
        'option': SendMessagePopMenuOptions.camera,
        'icon': AppStrings.selloutChatMenuPhotoIcon,
        'title': 'photo_camera'.tr(),
      },
      {
        'option': SendMessagePopMenuOptions.mediaLibrary,
        'icon': AppStrings.selloutChatMenuVideoIcon,
        'title': 'photo_video_library'.tr(),
      },
      {
        'option': SendMessagePopMenuOptions.document,
        'icon': AppStrings.selloutChatMenuDocumentIcon,
        'title': 'document'.tr(),
      },
      {
        'option': SendMessagePopMenuOptions.contacts,
        'icon': AppStrings.selloutChatMenuContactIcon,
        'title': 'contacts'.tr(),
      },
    ];

    return PopupMenuButton<SendMessagePopMenuOptions>(
      padding: EdgeInsets.zero,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, -240),
      onSelected: (option) {
        _rotationController.reverse();
        _handleAttachment(context, option);
      },
      onCanceled: () => _rotationController.reverse(),
      onOpened: () =>
          _rotationController.forward(), // rotate slightly when open
      itemBuilder: (_) => menuItems.map((item) {
        return _buildMenuItem(
          context,
          option: item['option'] as SendMessagePopMenuOptions,
          icon: item['icon'] as String,
          title: item['title'] as String,
          iconColor: iconColor,
        );
      }).toList(),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          );
        },
        child: CustomSvgIcon(assetPath: AppStrings.selloutChatPopMenuIcon),
      ),
    );
  }

  PopupMenuItem<SendMessagePopMenuOptions> _buildMenuItem(
    BuildContext context, {
    required SendMessagePopMenuOptions option,
    required String icon,
    required String title,
    Color? iconColor,
  }) {
    return PopupMenuItem<SendMessagePopMenuOptions>(
      value: option,
      child: Row(
        children: <Widget>[
          CustomSvgIcon(assetPath: icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
