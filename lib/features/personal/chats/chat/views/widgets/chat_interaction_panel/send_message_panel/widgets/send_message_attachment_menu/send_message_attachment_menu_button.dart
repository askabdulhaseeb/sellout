import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../providers/send_message_provider.dart';
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

  /// Calculates dynamic offset based on screen size and keyboard visibility
  Offset _calculateMenuOffset(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double availableHeight = screenHeight - keyboardHeight;

    // Menu has 4 items, approximately 56px each + padding
    const double menuHeight = 240.0;

    // Ensure menu doesn't go off screen
    final double offset = availableHeight > menuHeight + 100
        ? -menuHeight
        : -(availableHeight * 0.4);

    return Offset(0, offset);
  }

  @override
  Widget build(BuildContext context) {
    final Color? iconColor = Theme.of(context).iconTheme.color;
    final SendMessageProvider msgPro =
        Provider.of<SendMessageProvider>(context, listen: false);

    final List<Map<String, dynamic>> menuItems = <Map<String, dynamic>>[
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.camera,
        'icon': AppStrings.selloutChatMenuPhotoIcon,
        'title': 'photo_camera'.tr(),
      },
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.mediaLibrary,
        'icon': AppStrings.selloutChatMenuVideoIcon,
        'title': 'photo_video_library'.tr(),
      },
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.document,
        'icon': AppStrings.selloutChatMenuDocumentIcon,
        'title': 'document'.tr(),
      },
      <String, dynamic>{
        'option': SendMessagePopMenuOptions.contacts,
        'icon': AppStrings.selloutChatMenuContactIcon,
        'title': 'contacts'.tr(),
      },
    ];

    return PopupMenuButton<SendMessagePopMenuOptions>(
      padding: EdgeInsets.zero,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: _calculateMenuOffset(context),
      onSelected: (SendMessagePopMenuOptions option) {
        _rotationController.reverse();
        msgPro.closeAttachmentMenu();
        _handleAttachment(context, option);
      },
      onCanceled: () {
        _rotationController.reverse();
        msgPro.closeAttachmentMenu();
      },
      onOpened: () {
        _rotationController.forward();
        msgPro.openAttachmentMenu();
      },
      itemBuilder: (_) => menuItems.map((Map<String, dynamic> item) {
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
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          );
        },
        child:
            const CustomSvgIcon(assetPath: AppStrings.selloutChatPopMenuIcon),
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
