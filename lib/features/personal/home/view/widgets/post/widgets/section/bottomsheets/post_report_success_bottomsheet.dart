import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../../core/widgets/utils/in_dev_mode.dart';

void showReportSuccessBottomSheet(BuildContext context, String reason) {
  final ThemeData theme = Theme.of(context);
  final ColorScheme colorScheme = theme.colorScheme;
  final TextTheme textTheme = theme.textTheme;

  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // title
            Text(
              'post_reported_title'.tr(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // icon
            Icon(Icons.check_box_outlined, color: theme.primaryColor, size: 60),
            const SizedBox(height: 16),
            // message
            Text(
              '${'post_reported_message'.tr()} "$reason" ${'post_reported_message_extra'.tr()}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline.withValues(alpha: 0.4),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // done button
            CustomElevatedButton(
              onTap: () => Navigator.pop(context),
              title: 'done'.tr(),
              isLoading: false,
            ),
            // dev-only cancel button
            InDevMode(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'cancel_report'.tr(),
                  style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
