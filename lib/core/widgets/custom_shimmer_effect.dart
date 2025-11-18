import 'package:flutter/material.dart';

const LinearGradient _shimmerGradient = LinearGradient(
  colors: <Color>[
    Color(0xFFE7E7E7),
    Color(0xFFFDFDFD),
    Color(0xFFE7E7E7),
  ],
  stops: <double>[0.25, 0.5, 0.75],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    required this.isLoading,
    required this.child,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        // Shift gradient to create shimmer effect
        final double slidePercent = _controller.value * 2 - 1; // -1 to 1
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            final Rect rect = Rect.fromLTWH(
              bounds.width * slidePercent,
              0.0,
              bounds.width,
              bounds.height,
            );
            return _shimmerGradient.createShader(rect);
          },
          child: widget.child,
        );
      },
    );
  }
}
