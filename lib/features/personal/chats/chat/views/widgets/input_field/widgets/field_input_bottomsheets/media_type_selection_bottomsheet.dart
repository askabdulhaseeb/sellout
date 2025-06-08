import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';


void showMediaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
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
              subtitle: Text('Upload a photo from your library'.tr()),
              onTap: () {
                Navigator.pop(context);
                // Handle photo selection
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.video_collection_outlined,
                color: AppTheme.primaryColor,
              ),
              title: Text('video_library'.tr()),
              subtitle: Text('Upload a video from your library'.tr()),
              onTap: () {
                Navigator.pop(context);
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
