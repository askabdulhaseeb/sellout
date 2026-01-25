import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Moved to ui/info_notice.dart
class InfoNotice extends StatelessWidget {
  const InfoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.info_outline, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            tr('size_selection_notice'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
