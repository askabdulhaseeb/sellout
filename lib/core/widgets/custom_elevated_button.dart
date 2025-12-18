import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    required this.title,
    required this.isLoading,
    required this.onTap,
    this.isSuccess = false,
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
    this.loadingTitle,
    this.loadingWidget,
    this.successWidget,
    this.successDuration = const Duration(seconds: 1),
    this.onSuccessComplete,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDisable;
  final bool isLoading;
  final bool isSuccess;
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
  final String? loadingTitle;
  final Widget? loadingWidget;
  final Widget? successWidget;
  final Duration successDuration;
  final VoidCallback? onSuccessComplete;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _showSuccess = false;

  @override
  void didUpdateWidget(CustomElevatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _showSuccess = true;
      Future<void>.delayed(widget.successDuration, () {
        if (mounted) {
          setState(() {
            _showSuccess = false;
          });
          widget.onSuccessComplete?.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color successColor = colorScheme.secondary;
    final Color onSuccessColor = colorScheme.onSecondary;
    final bool isInSuccessState = widget.isSuccess || _showSuccess;
    final Color bgColorCore = widget.isDisable
        ? colorScheme.outlineVariant
        : isInSuccessState
        ? successColor
        : widget.bgColor ?? colorScheme.primary;

    final Color? overlayColor = widget.isDisable
        ? null
        : colorScheme.secondary.withValues(alpha: 0.12);

    final TextStyle effectiveTextStyle =
        (widget.textStyle ??
                (TextTheme.of(context).bodyLarge ?? const TextStyle()))
            .copyWith(
              fontWeight: widget.fontWeight,
              // Keep previous behavior: if textStyle is provided, don't inject a
              // computed color unless textColor is explicitly set.
              color:
                  widget.textColor ??
                  widget.textStyle?.color ??
                  (widget.textStyle != null
                      ? null
                      : (widget.bgColor == Colors.transparent
                            ? colorScheme.onSurface
                            : colorScheme.onPrimary)),
            );

    final BoxBorder? resolvedBorder = () {
      if (widget.border == null) {
        return Border.all(color: bgColorCore);
      }

      if (isInSuccessState && widget.border is Border) {
        final Border b = widget.border! as Border;
        return Border(
          top: b.top.copyWith(color: successColor),
          right: b.right.copyWith(color: successColor),
          bottom: b.bottom.copyWith(color: successColor),
          left: b.left.copyWith(color: successColor),
        );
      }

      if (widget.isDisable && widget.border is Border) {
        final Border b = widget.border! as Border;
        return Border(
          top: b.top.copyWith(color: bgColorCore),
          right: b.right.copyWith(color: bgColorCore),
          bottom: b.bottom.copyWith(color: bgColorCore),
          left: b.left.copyWith(color: bgColorCore),
        );
      }

      return widget.border;
    }();

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColorCore,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        border: resolvedBorder,
      ),
      child: Material(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        color: bgColorCore,
        child: InkWell(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          hoverColor: overlayColor,
          highlightColor: overlayColor,
          splashColor: overlayColor,
          onTap: (widget.isDisable || widget.isLoading || isInSuccessState)
              ? null
              : widget.onTap,
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment:
                  widget.rowAlignment ?? MainAxisAlignment.center,
              children: <Widget>[
                if (!widget.isLoading &&
                    !isInSuccessState &&
                    widget.prefix != null)
                  Padding(
                    padding:
                        widget.prefixSuffixPadding ?? const EdgeInsets.all(8.0),
                    child: widget.prefix!,
                  ),
                if (widget.isLoading)
                  widget.loadingWidget ??
                      Text(
                        widget.loadingTitle ?? 'Loading...',
                        style: effectiveTextStyle,
                      )
                else if (isInSuccessState)
                  widget.successWidget ??
                      Icon(
                        Icons.check,
                        color: widget.textColor ?? onSuccessColor,
                        size: 24,
                      )
                else
                  Text(widget.title, style: effectiveTextStyle),
                if (!widget.isLoading &&
                    !isInSuccessState &&
                    widget.suffix != null)
                  Padding(
                    padding:
                        widget.prefixSuffixPadding ?? const EdgeInsets.all(8.0),
                    child: widget.suffix!,
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
  }) : dotSize = dotSize ?? 6,
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
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[_dot(_a1), _dot(_a2), _dot(_a3)],
    );
  }
}
