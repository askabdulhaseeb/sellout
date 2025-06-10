import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/chat_provider.dart';
void showCameraPickerBottomSheet(BuildContext context) async {
  final List<CameraDescription> cameras = await availableCameras();
final CameraDescription camera = cameras.first;
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
                final PickedAttachment? picked = await pickFromCamera(
                  isVideo: false,
                  camera: camera,
                );
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
                final PickedAttachment? picked = await pickFromCamera(
                  isVideo: true,
                  camera: camera,
                );
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
Future<PickedAttachment?> pickFromCamera({
  required bool isVideo,
  required CameraDescription camera,
}) async {
  final PermissionStatus cameraStatus = await Permission.camera.request();
  if (!cameraStatus.isGranted) return null;

  final CameraController controller = CameraController(
    camera,
    ResolutionPreset.medium,
    enableAudio: isVideo,
  );

  await controller.initialize();

  final XFile? capturedFile;

  if (isVideo) {
    await controller.startVideoRecording();
    await Future.delayed(const Duration(seconds: 5)); // auto-stop after 5 sec
    capturedFile = await controller.stopVideoRecording();
  } else {
    capturedFile = await controller.takePicture();
  }

  await controller.dispose();

  if (!File(capturedFile.path).existsSync()) {
    return null;
  }

  final File file = File(capturedFile.path);

  AssetEntity? entity;
  if (isVideo) {
    entity = await PhotoManager.editor.saveVideo(file);
  } else {
    entity = await PhotoManager.editor.saveImageWithPath(file.path);
  }

  return PickedAttachment(
    file: file,
    type: isVideo ? AttachmentType.video : AttachmentType.image,
    selectedMedia: entity,
  );
}
