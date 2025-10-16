import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_page_widget.dart';

class EmptyGalleryState extends StatelessWidget {
  const EmptyGalleryState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyPageWidget(
        icon: Icons.photo_library_rounded,
        childBelow: Column(
          children: <Widget>[
            Text(
              'no_photos_found'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.8),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'empty_gallery_message'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
