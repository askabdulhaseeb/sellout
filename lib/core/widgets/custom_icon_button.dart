import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onPressed,
    this.bgColor,
    this.iconColor,
    this.margin,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    super.key,
  });

  final IconData icon;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = borderRadius ?? BorderRadius.circular(8);
    return Padding(
      padding: margin ?? const EdgeInsets.all(6),
      child: Material(
        color: bgColor ?? Theme.of(context).disabledColor.withAlpha(10),
        borderRadius: br,
        child: InkWell(
          onTap: onPressed,
          borderRadius: br,
          child: Container(
            padding: padding ?? const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: br,
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 1.0,
              ),
            ),
            child: Icon(icon, color: iconColor),
          ),
        ),
      ),
    );
  }
}
