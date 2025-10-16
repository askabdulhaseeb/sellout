import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_spacings.dart';
import '../providers/picked_media_provider.dart';

class MediaAppBar extends StatelessWidget {
  const MediaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider provider, _) {
        final int selectedCount = provider.pickedMedia.length;
        final int maxCount = provider.option.maxAttachments;
        final double progress = (selectedCount / maxCount).clamp(0.0, 1.0);

        return SliverAppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.3,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          title: Row(
            children: <Widget>[
              IconButton.filledTonal(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        '${'select'.tr()} ($selectedCount/$maxCount)',
                        key: ValueKey(selectedCount),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.vSm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: provider.pickedMedia.isEmpty
                      ? Theme.of(context).colorScheme.surface.withOpacity(0.3)
                      : Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: provider.pickedMedia.isEmpty
                      ? null
                      : () => provider.onSubmit(context),
                  icon: Icon(
                    Icons.check_rounded,
                    color: provider.pickedMedia.isEmpty
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
