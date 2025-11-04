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

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.width = 36,
    this.height = 20,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          color: value
              ? (activeColor ?? colorScheme.secondary.withValues(alpha: 0.7))
              : (inactiveColor ?? colorScheme.outline.withValues(alpha: 0.3)),
          boxShadow: value
              ? <BoxShadow>[
                  BoxShadow(
                    color: (activeColor ?? colorScheme.secondary)
                        .withValues(alpha: 0.25),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  )
                ]
              : <BoxShadow>[],
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          width: height * 0.8,
          height: height * 0.8,
          decoration: BoxDecoration(
            color: thumbColor ??
                (value
                    ? colorScheme.onSecondary
                    : colorScheme.surfaceContainerHighest),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 1.2,
                offset: const Offset(0, 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
