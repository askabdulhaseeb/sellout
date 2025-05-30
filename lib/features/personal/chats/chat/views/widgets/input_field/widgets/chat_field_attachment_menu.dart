import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../providers/chat_provider.dart';

class AttachmentMenuButton extends StatelessWidget {
  const AttachmentMenuButton({super.key});

  Future<PickedAttachment?> pickFromCamera({bool isVideo = false}) async {
    final ImagePicker picker = ImagePicker();
    final PermissionStatus cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) return null;

    final XFile? file = isVideo
        ? await picker.pickVideo(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.camera);

    if (file == null) return null;

    final File imageFile = File(file.path);
    if (!imageFile.existsSync()) return null;

    final AssetEntity entity =
        await PhotoManager.editor.saveImageWithPath(imageFile.path);

    return PickedAttachment(
      file: imageFile,
      type: isVideo ? AttachmentType.video : AttachmentType.image,
      selectedMedia: entity,
    );
  }

  void onCameraButtonPressed(BuildContext context) async {
    final PickedAttachment? picked =
        await pickFromCamera(isVideo: false); // change to true for video
    if (picked != null) {
      Provider.of<ChatProvider>(context, listen: false).addAttachment(picked);
    }
  }

  void _handleAttachment(BuildContext context, int value) async {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    switch (value) {
      case 0:
        onCameraButtonPressed(context);
        break;
      case 1:
        pro.setImages(context);
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accessing location...')),
        );
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecting document...')),
        );
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accessing contacts...')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: Theme.of(context).scaffoldBackgroundColor,
      icon: const Icon(Icons.add_circle_outline_outlined),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (int value) => _handleAttachment(context, value),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        _buildMenuItem(
            context, 0, Icons.photo_camera_outlined, 'photo_camera'.tr()),
        _buildMenuItem(context, 1, Icons.photo_library_outlined,
            'photo_video_library'.tr()),
        _buildMenuItem(context, 2, Icons.location_on_outlined, 'location'.tr()),
        _buildMenuItem(
            context, 3, Icons.insert_drive_file_outlined, 'document'.tr()),
        _buildMenuItem(
            context, 4, Icons.contact_page_outlined, 'contacts'.tr()),
      ],
    );
  }

  PopupMenuItem<int> _buildMenuItem(
    BuildContext context,
    int value,
    IconData icon,
    String title,
  ) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
            size: 16,
          ),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
