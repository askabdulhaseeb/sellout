import 'package:flutter/material.dart';

/// A unified container widget for rich message tiles (offer, quote, visiting).
/// Replaces duplicated container styling across multiple tile implementations.
class MessageContainer extends StatelessWidget {
  const MessageContainer({
    required this.child,
    this.showBorder = true,
    this.borderRadius = 8,
    this.padding,
    this.margin,
    this.animate = false,
    super.key,
  });

  final Widget child;

  /// Controls border visibility. When false, border is transparent.
  final bool showBorder;

  /// Border radius of the container. Default: 8
  final double borderRadius;

  /// Inner padding. Default: EdgeInsets.all(12)
  final EdgeInsets? padding;

  /// Outer margin. Default: EdgeInsets.all(16) when showBorder is true, 0 otherwise
  final EdgeInsets? margin;

  /// Whether to animate container changes
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets effectiveMargin =
        margin ?? EdgeInsets.all(showBorder ? 16 : 0);
    final EdgeInsets effectivePadding =
        padding ?? const EdgeInsets.all(12);
    final BoxDecoration decoration = BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: showBorder
            ? ColorScheme.of(context).outlineVariant
            : Colors.transparent,
      ),
    );

    if (animate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: effectiveMargin,
        padding: effectivePadding,
        decoration: decoration,
        child: child,
      );
    }

    return Container(
      margin: effectiveMargin,
      padding: effectivePadding,
      decoration: decoration,
      child: child,
    );
  }
}
