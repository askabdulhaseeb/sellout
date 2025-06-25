import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../core/widgets/in_dev_mode.dart';

void showReportSuccessBottomSHeet(BuildContext context, String reason) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'post_reported_title'.tr(), // e.g. The Post has been reported
              style: TextTheme.of(context).titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorScheme.of(context).onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.check_box_outlined,
              color: Theme.of(context).primaryColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              '${'post_reported_message'.tr()} "$reason" ${'post_reported_message_extra'.tr()}',
              style: TextTheme.of(context).bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'done'.tr(),
                isLoading: false,
              ),
            ),
            InDevMode(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'cancel_report'.tr(),
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
