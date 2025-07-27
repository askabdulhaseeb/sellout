import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../providers/send_message_provider.dart';

void showMediaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      final SendMessageProvider chatPro =
          Provider.of<SendMessageProvider>(context, listen: false);
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppTheme.primaryColor,
              ),
              title: Text('photo_library'.tr()),
              subtitle: Text('upload_photo_from_library'.tr()),
              onTap: () {
                Navigator.pop(context);

                chatPro.setImages(context, type: AttachmentType.image);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.video_collection_outlined,
                color: AppTheme.primaryColor,
              ),
              title: Text('video_library'.tr()),
              subtitle: Text('upload_a_video_from_library'.tr()),
              onTap: () {
                Navigator.pop(context);

                chatPro.setImages(context, type: AttachmentType.video);
                // Handle video selection
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
