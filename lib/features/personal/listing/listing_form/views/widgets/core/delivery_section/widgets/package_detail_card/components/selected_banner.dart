import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../../../core/constants/app_spacings.dart';

class SelectedBanner extends StatelessWidget {
  const SelectedBanner(
      {required this.dimsText, required this.presetLabel, super.key});

  final String? dimsText;
  final String? presetLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool hasSelection = dimsText != null && dimsText!.isNotEmpty;
    final String title =
        hasSelection ? tr('selected') : tr('select_package_size');
    final String? detail = hasSelection
        ? (presetLabel != null ? '$presetLabel ($dimsText)' : dimsText)
        : null;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.hSm, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            hasSelection ? Icons.check_circle : Icons.inventory_2_outlined,
            size: 16,
            color: hasSelection ? scheme.primary : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (detail != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: scheme.onSurface,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
