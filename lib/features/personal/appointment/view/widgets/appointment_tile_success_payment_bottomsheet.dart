import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';

void showSuccessBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'payment_complete'.tr(),
              style: TextTheme.of(context).titleSmall,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 50),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle),
                  child: Center(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle),
                      child: const Center(
                          child: Icon(Icons.check_circle_outline_rounded,
                              color: AppTheme.primaryColor, size: 64)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'thank_you'.tr(),
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context).titleMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'appointment_success_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context)
                      .bodyMedium
                      ?.copyWith(color: ColorScheme.of(context).outline),
                ),
              ],
            ),
          ),
          bottomSheet: BottomAppBar(
            height: 120,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomElevatedButton(
                onTap: () => Navigator.pop(context),
                title: 'done'.tr(),
                isLoading: false,
              ),
            ),
          ));
    },
  );
}
