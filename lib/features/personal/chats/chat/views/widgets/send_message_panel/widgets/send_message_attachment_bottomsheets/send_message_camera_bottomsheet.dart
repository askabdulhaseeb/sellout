import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/send_message_provider.dart';

void showCameraPickerBottomSheet(BuildContext context) async {
  final SendMessageProvider chatPro =
      Provider.of<SendMessageProvider>(context, listen: false);
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
              title: Text('take_photo'.tr()),
              onTap: () async {
                Navigator.pop(context);
                final PickedAttachment? picked =
                    await pickFromCamera(isVideo: false);
                if (picked != null) {
                  chatPro.addAttachment(picked);
                  chatPro.sendMessage(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('record_video'.tr()),
              onTap: () async {
                Navigator.pop(context);
                final PickedAttachment? picked =
                    await pickFromCamera(isVideo: true);
                if (picked != null) {
                  chatPro.addAttachment(picked);
                  chatPro.sendMessage(context);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<PickedAttachment?> pickFromCamera({required bool isVideo}) async {
  final PermissionStatus cameraStatus = await Permission.camera.request();
  if (!cameraStatus.isGranted) return null;

  final ImagePicker picker = ImagePicker();
  final XFile? file = isVideo
      ? await picker.pickVideo(source: ImageSource.camera)
      : await picker.pickImage(source: ImageSource.camera);

  if (file == null) return null;

  final File finalFile = File(file.path);

  PickedAttachment? entity;
  if (isVideo) {
    entity = PickedAttachment(file: finalFile, type: AttachmentType.video);
  } else {
    entity = PickedAttachment(file: finalFile, type: AttachmentType.image);
  }

  return entity;
}
