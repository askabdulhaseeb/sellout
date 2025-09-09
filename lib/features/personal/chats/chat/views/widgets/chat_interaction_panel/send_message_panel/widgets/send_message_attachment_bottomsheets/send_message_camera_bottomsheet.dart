import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/enums/core/attachment_type.dart';
import '../../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../../providers/send_message_provider.dart';

void showCameraPickerBottomSheet(BuildContext context) async {
  final SendMessageProvider chatPro =
      Provider.of<SendMessageProvider>(context, listen: false);
  showModalBottomSheet(
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              leading: const Icon(
                Icons.camera_alt,
                color: AppTheme.primaryColor,
              ),
              title: Text('take_photo'.tr()),
              onTap: () async {
                Navigator.pop(context);
                final PickedAttachment? picked =
                    await pickFromCamera(isVideo: false, context: context);
                if (picked != null) {
                  chatPro.addAttachment(picked);
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.video_call,
                color: AppTheme.primaryColor,
              ),
              title: Text('record_video'.tr()),
              onTap: () async {
                Navigator.pop(context);
                final PickedAttachment? picked =
                    await pickFromCamera(isVideo: true, context: context);
                if (picked != null) {
                  chatPro.addAttachment(picked);
                }
              },
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'done'.tr(),
              isLoading: false,
            ),
          ],
        ),
      );
    },
  );
}

Future<PickedAttachment?> pickFromCamera({
  required bool isVideo,
  required BuildContext context,
}) async {
  final PermissionStatus cameraStatus = await Permission.camera.request();

  if (!cameraStatus.isGranted) {
    AppSnackBar.showSnackBar(
      context,
      'camera_permission_denied'.tr(),
    );
    return null; // Cannot proceed without permission
  }
  final ImagePicker picker = ImagePicker();
  final XFile? file = isVideo
      ? await picker.pickVideo(source: ImageSource.camera)
      : await picker.pickImage(source: ImageSource.camera);
  if (file == null) return null;
  final File finalFile = File(file.path);

  return PickedAttachment(
    file: finalFile,
    type: isVideo ? AttachmentType.video : AttachmentType.image,
  );
}
