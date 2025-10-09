import 'package:flutter/material.dart';

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
      contentPadding: const EdgeInsets.all(0),
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
