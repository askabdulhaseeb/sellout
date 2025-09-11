import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    required this.value,
    required this.onChanged,
    required this.title,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      dense: true,
      activeTrackColor: AppTheme.secondaryColor,
      thumbColor: WidgetStateProperty.all(colorScheme.onSecondary),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      thumbIcon: WidgetStateProperty.all(
        Icon(
          Icons.circle,
          color: colorScheme.onSecondary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w400))
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
