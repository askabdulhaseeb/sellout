import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? color;
  final Decoration? decoration;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: decoration ??
            BoxDecoration(
              color: color ?? Theme.of(context).scaffoldBackgroundColor,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              boxShadow: boxShadow ??
                  <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .color!
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
            ),
        child: child,
      ),
    );
  }
}
