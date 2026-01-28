import 'package:flutter/material.dart';

import '../indicators/custom_shimmer_effect.dart';


class LoaderContainer extends StatelessWidget {
  const LoaderContainer({
    super.key,
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 8,
    this.color,
    this.strokeWidth = 2,
  });

  final double height;
  final double width;
  final double borderRadius;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
