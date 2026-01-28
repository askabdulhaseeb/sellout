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
    this.iconWidget,
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
  final Widget? iconWidget;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool? selected;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected ?? value == groupValue;
    final colorScheme = Theme.of(context).colorScheme;
    final Color effectiveActiveColor = activeColor ?? colorScheme.primary;

    return InkWell(
      borderRadius: borderRadius,
      onTap: () => onChanged(value),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer.withOpacity(0.18)
              : colorScheme.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: isSelected ? effectiveActiveColor : colorScheme.outline,
            width: borderWidth,
          ),
        ),
        child: Row(
          children: [
            _IconBgWrapper(
              isSelected: isSelected,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              colorScheme: colorScheme,
              child:
                  iconWidget ??
                  Icon(
                    icon,
                    size: 28,
                    color: isSelected
                        ? effectiveActiveColor
                        : colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _TileText(
                title: title,
                subtitle: subtitle,
                isSelected: isSelected,
                colorScheme: colorScheme,
              ),
            ),
            _RadioIndicator(isSelected: isSelected, colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }
}

class _TileText extends StatelessWidget {
  const _TileText({
    required this.title,
    required this.isSelected,
    required this.colorScheme,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _IconBgWrapper extends StatelessWidget {
  const _IconBgWrapper({
    required this.child,
    required this.isSelected,
    required this.colorScheme,
    this.activeColor,
    this.inactiveColor,
  });

  final Widget child;
  final bool isSelected;
  final ColorScheme colorScheme;
  final Color? activeColor;
  final Color? inactiveColor;

  Color _lighten(Color color, [double amount = 0.65]) {
    // Returns a lighter shade of the color (amount: 0.0 = no change, 1.0 = white)
    final hsl = HSLColor.fromColor(color);
    final double newLightness = hsl.lightness + (1.0 - hsl.lightness) * amount;
    return hsl.withLightness(newLightness.clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseActive = activeColor ?? colorScheme.primary;
    final Color bgColor = isSelected
        ? _lighten(baseActive, 0.65)
        : (inactiveColor ?? colorScheme.surfaceVariant);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.isSelected, required this.colorScheme});

  final bool isSelected;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
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
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: 2,
            ),
            color: colorScheme.surface,
          ),
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
