import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.title,
    required this.isLoading,
    required this.onTap,
    this.isDisable = false,
    this.prefix,
    this.suffix,
    this.rowAlignment,
    this.mWidth,
    this.margin,
    this.padding,
    this.bgColor,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.textColor,
    this.prefixSuffixPadding,
    this.fontWeight = FontWeight.w400,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDisable;
  final bool isLoading;
  final double? mWidth;
  final Widget? prefix;
  final Widget? suffix;
  final MainAxisAlignment? rowAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Color? textColor;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? prefixSuffixPadding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color bgColorCore =
        isDisable ? colorScheme.outlineVariant : bgColor ?? colorScheme.primary;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColorCore,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: border ?? Border.all(color: bgColorCore),
      ),
      child: Material(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: bgColorCore,
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          onTap: (isDisable || isLoading) ? null : onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: rowAlignment ?? MainAxisAlignment.center,
              children: <Widget>[
                if (!isLoading && prefix != null)
                  Padding(
                    padding: prefixSuffixPadding ?? const EdgeInsets.all(8.0),
                    child: prefix!,
                  ),
                if (isLoading)
                  _PulsingDots(
                    color: textColor ??
                        (bgColor == Colors.transparent
                            ? colorScheme.onSurface
                            : colorScheme.onPrimary),
                  )
                else
                  Text(
                    title,
                    style: textStyle ??
                        TextStyle(
                            color: textColor ??
                                (bgColor == Colors.transparent
                                    ? colorScheme.onSurface
                                    : colorScheme.onPrimary),
                            fontWeight: fontWeight),
                  ),
                if (!isLoading && suffix != null)
                  Padding(
                    padding: prefixSuffixPadding ?? const EdgeInsets.all(8.0),
                    child: suffix!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots({
    required this.color,
    double? dotSize,
    double? spacing,
    Duration? duration,
  })  : dotSize = dotSize ?? 6,
        spacing = spacing ?? 4,
        duration = duration ?? const Duration(milliseconds: 1200);

  final Color color;
  final double dotSize;
  final double spacing;
  final Duration duration;

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _a1;
  late final Animation<double> _a2;
  late final Animation<double> _a3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _a1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    );
    _a2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    );
    _a3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> anim) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.6, end: 1.0).animate(anim),
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _dot(_a1),
        _dot(_a2),
        _dot(_a3),
      ],
    );
  }
}
