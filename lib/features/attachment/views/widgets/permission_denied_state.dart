import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/widgets/empty_page_widget.dart';

class PermissionDeniedState extends StatelessWidget {
  const PermissionDeniedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyPageWidget(
        icon: Icons.photo_library_rounded,
        iconColor: Theme.of(context).colorScheme.error,
        childBelow: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Text(
                'permission_gallery_title'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'permission_gallery_body'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: PhotoManager.openSetting,
                child: Text('open_settings'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
