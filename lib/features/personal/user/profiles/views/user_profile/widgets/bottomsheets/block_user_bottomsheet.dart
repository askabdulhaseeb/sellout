import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';

Future<bool?> showBlockUserBottomSheet(
  BuildContext context, {
  required String name,
}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextTheme textTheme = Theme.of(context).textTheme;

  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.vLg),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.block_rounded,
                  color: colorScheme.error,
                  size: 36,
                ),
              ),
              const SizedBox(height: AppSpacing.vLg),
              Text(
                'block_user_question'.tr(
                  namedArgs: <String, String>{'name': name},
                ),
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.vMd),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.do_not_disturb_on_outlined,
                    color: colorScheme.onSurface,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.hSm),
                  Expanded(
                    child: Text(
                      'block_modal_bullet_message'.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.vSm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.visibility_off_outlined,
                    color: colorScheme.onSurface,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.hSm),
                  Expanded(
                    child: Text(
                      'block_modal_bullet_notify'.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.vXl),
              CustomElevatedButton(
                title: 'block_user_action'.tr(),
                onTap: () => Navigator.of(context).pop(true),
                isLoading: false,
                bgColor: colorScheme.error,
                textColor: colorScheme.onError,
              ),
              CustomElevatedButton(
                title: 'cancel'.tr(),
                onTap: () => Navigator.of(context).pop(false),
                isLoading: false,
                bgColor: Colors.transparent,
                textColor: colorScheme.onSurface,
              ),
              const SizedBox(height: AppSpacing.vSm),
            ],
          ),
        ),
      ),
    ),
  );
}
