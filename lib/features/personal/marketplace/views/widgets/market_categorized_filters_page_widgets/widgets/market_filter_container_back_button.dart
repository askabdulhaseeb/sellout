import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GoBAckButtonWidget extends StatelessWidget {
  const GoBAckButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
      ),
      icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurfaceVariant),
      onPressed: () {
        Navigator.pop(context);
      },
      label: Text('go_back'.tr()),
    );
  }
}
