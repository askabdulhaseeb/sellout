import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_spacings.dart';
import '../providers/picked_media_provider.dart';
import 'app_bar_components/back_button.dart';
import 'app_bar_components/selection_counter.dart';
import 'app_bar_components/progress_bar.dart';
import 'app_bar_components/submit_button.dart';

class MediaAppBar extends StatelessWidget {
  const MediaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider provider, _) {
        final int selectedCount = provider.pickedMedia.length;
        final int maxCount = provider.option.maxAttachments;
        final double progress = (selectedCount / maxCount).clamp(0.0, 1.0);
        final bool hasSelection = selectedCount > 0;

        return SliverAppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.3,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          title: Row(
            children: <Widget>[
              // --- BACK BUTTON ---
              AppBarBackButton(
                onPressed: () => Navigator.pop(context),
                isActive: hasSelection,
              ),
              const SizedBox(width: AppSpacing.md),

              // --- SELECTION INFO (Counter + Progress) ---
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectionCounter(
                      selectedCount: selectedCount,
                      maxCount: maxCount,
                      label: 'select'.tr(),
                    ),
                    const SizedBox(height: AppSpacing.vSm),
                    SelectionProgressBar(progress: progress),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // --- SUBMIT BUTTON ---
              SubmitButton(
                isActive: hasSelection,
                onPressed:
                    hasSelection ? () => provider.onSubmit(context) : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
