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
    super.key,
  });
  final IconData icon;
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = borderRadius ?? BorderRadius.circular(8);
    return Padding(
      padding: margin ?? const EdgeInsets.all(6),
      child: Material(
        color: bgColor ?? Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: br,
        child: InkWell(
          onTap: onPressed,
          borderRadius: br,
          child: Container(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: Icon(icon, color: iconColor),
          ),
        ),
      ),
    );
  }
}
