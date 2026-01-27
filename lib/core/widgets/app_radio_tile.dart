import 'package:flutter/material.dart';

/// A custom radio tile widget that mimics the look and feel of a RadioListTile,
/// but does not use deprecated properties and is fully customizable.
class AppRadioTile<T> extends StatelessWidget {
  const AppRadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.activeColor,
    this.inactiveColor,
    this.selected,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.borderWidth = 2.0,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool? selected;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected ?? value == groupValue;
    final Color effectiveActiveColor =
        activeColor ?? Theme.of(context).colorScheme.primary;
    final Color effectiveInactiveColor = inactiveColor ?? Colors.grey.shade400;
    final Color borderColor = isSelected
        ? effectiveActiveColor
        : Colors.grey.shade300;
    final Color tileColor = isSelected
        ? effectiveActiveColor.withValues(alpha: 0.08)
        : Colors.transparent;

    return InkWell(
      borderRadius: borderRadius,
      onTap: () => onChanged(value),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: borderRadius,
          color: tileColor,
        ),
        padding: padding,
        child: Row(
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                color: isSelected
                    ? effectiveActiveColor
                    : effectiveInactiveColor,
                size: 28,
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected
                          ? effectiveActiveColor
                          : effectiveInactiveColor,
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Custom radio indicator with pop-in animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              builder: (BuildContext context, double scale, Widget? child) {
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? effectiveActiveColor
                          : effectiveInactiveColor,
                      width: 2,
                    ),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? effectiveActiveColor
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
