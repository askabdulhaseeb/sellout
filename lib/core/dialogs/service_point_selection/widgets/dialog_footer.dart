import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../features/postage/data/models/service_points_response_model.dart';
import '../../../constants/app_spacings.dart';

/// Footer with action buttons for service point selection dialog
class DialogFooter extends StatelessWidget {
  const DialogFooter({
    required this.selectedPoint,
    super.key,
  });

  final ServicePointModel? selectedPoint;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Text('cancel'.tr()),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: selectedPoint != null
                  ? () => Navigator.pop(context, selectedPoint)
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.outline,
              ),
              child: Text(
                'confirm_pickup_location'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
