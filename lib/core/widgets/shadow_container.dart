import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    required this.child,
    this.padding,
    this.color,
    this.decoration,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
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
                          .withOpacity(0.2),
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
