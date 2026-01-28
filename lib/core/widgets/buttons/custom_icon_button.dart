import 'package:flutter/material.dart';

import '../custom_svg_icon.dart';

class CustomIconButton extends StatefulWidget {
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
    this.iconSize,
    this.alternateIcon,
    this.enableTransition = false,
    this.transitionDuration = const Duration(milliseconds: 300),
    super.key,
  });

  final dynamic icon; // can be String (SVG) or IconData
  final dynamic alternateIcon; // optional alternate icon
  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final double? iconSize;
  final bool enableTransition;
  final Duration transitionDuration;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool toggled = false;

  void _handleTap() {
    if (widget.alternateIcon != null && widget.enableTransition) {
      setState(() {
        toggled = !toggled;
      });
    }
    widget.onPressed();
  }

  Widget _buildIcon(dynamic icon) {
    if (icon is String) {
      return CustomSvgIcon(
        assetPath: icon,
        color: widget.iconColor,
        size: widget.iconSize ?? 24,
      );
    } else if (icon is IconData) {
      return Icon(
        icon,
        color: widget.iconColor,
        size: widget.iconSize ?? 24,
      );
    } else {
      throw ArgumentError(
          'icon must be either a String (SVG asset path) or IconData');
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius br = widget.borderRadius ?? BorderRadius.circular(8);

    return Padding(
      padding: widget.margin ?? const EdgeInsets.all(6),
      child: Material(
        color: widget.bgColor ?? Theme.of(context).disabledColor.withAlpha(10),
        borderRadius: br,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: br,
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: br,
              border: Border.all(
                color: widget.borderColor ?? Colors.transparent,
                width: widget.borderWidth ?? 1.0,
              ),
            ),
            child: widget.enableTransition
                ? AnimatedSwitcher(
                    duration: widget.transitionDuration,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            RotationTransition(turns: animation, child: child),
                    child: _buildIcon(
                      toggled
                          ? (widget.alternateIcon ?? widget.icon)
                          : widget.icon,
                    ),
                  )
                : _buildIcon(
                    toggled
                        ? (widget.alternateIcon ?? widget.icon)
                        : widget.icon,
                  ),
          ),
        ),
      ),
    );
  }
}
