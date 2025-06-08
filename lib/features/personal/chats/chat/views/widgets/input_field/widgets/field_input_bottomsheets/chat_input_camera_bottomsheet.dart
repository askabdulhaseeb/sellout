import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/chat_provider.dart';

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

void showCameraPickerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final PickedAttachment? picked = await pickFromCamera(isVideo: false);
                if (picked != null) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .addAttachment(picked);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () async {
                Navigator.pop(context);
                final PickedAttachment? picked = await pickFromCamera(isVideo: true);
                if (picked != null) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .addAttachment(picked);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
