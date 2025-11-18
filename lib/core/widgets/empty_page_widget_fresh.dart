import 'dart:math';

import 'package:flutter/material.dart';

class EmptyPageWidget extends StatefulWidget {
  const EmptyPageWidget({
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.childBelow,
    super.key,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Widget? childBelow;

  @override
  State<EmptyPageWidget> createState() => _EmptyPageWidgetState();
}

class _EmptyPageWidgetState extends State<EmptyPageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Animate from 0 → 1 once when created
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        widget.backgroundColor ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 20, width: double.infinity),
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor.withValues(alpha: 0.15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: baseColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? baseColor,
                size: 40,
              ),
            ),
          ),
        ),
        if (widget.childBelow != null) ...<Widget>[
          const SizedBox(height: 12),
          widget.childBelow!,
        ],
      ],
    );
  }
}

class CosmicRotatingLoader extends StatefulWidget {
  const CosmicRotatingLoader({super.key});

  @override
  State<CosmicRotatingLoader> createState() => _CosmicRotatingLoaderState();
}

class _CosmicRotatingLoaderState extends State<CosmicRotatingLoader>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 6 rotating category icons
            AnimatedBuilder(
              animation: _rotationController,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: _SixCategoryLoaderPainter(
                    rotationProgress: _rotationController.value,
                    primaryColor: Theme.of(context).primaryColor,
                    accentColor: Theme.of(context).colorScheme.secondary,
                  ),
                );
              },
            ),
            // Center "Sellout" text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SELLOUT',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 1.5,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SixCategoryLoaderPainter extends CustomPainter {
  _SixCategoryLoaderPainter({
    required this.rotationProgress,
    required this.primaryColor,
    required this.accentColor,
  });

  final double rotationProgress;
  final Color primaryColor;
  final Color accentColor;

  // 6 category icons arranged in a circle
  static const List<IconData> categoryIcons = [
    Icons.home,
    Icons.shopping_bag,
    Icons.pets,
    Icons.directions_car,
    Icons.restaurant,
    Icons.build,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = 35;

    // Draw 6 category icons in a circle
    for (int i = 0; i < categoryIcons.length; i++) {
      final double angle =
          (i / categoryIcons.length) * 2 * pi + (rotationProgress * 2 * pi);

      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);

      // Depth effect based on position
      final double depthFactor = 0.5 + (sin(angle) * 0.5);

      // Alternate colors
      final Color iconColor = i.isEven ? primaryColor : accentColor;

      // Draw icon with glow
      _drawCategoryIcon(
        canvas,
        Offset(x, y),
        categoryIcons[i],
        iconColor,
        depthFactor,
      );
    }
  }

  void _drawCategoryIcon(
    Canvas canvas,
    Offset position,
    IconData iconData,
    Color color,
    double depthFactor,
  ) {
    final double iconRadius = 8 + (depthFactor * 3);
    final double opacity = 0.6 + (depthFactor * 0.4);

    // Draw glow/shadow
    canvas.drawCircle(
      position,
      iconRadius + 2,
      Paint()
        ..color = color.withValues(alpha: 0.15 * depthFactor)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Draw background circle
    canvas.drawCircle(
      position,
      iconRadius,
      Paint()..color = color.withValues(alpha: opacity),
    );

    // Draw icon
    _drawIcon(
      canvas,
      position,
      iconData,
      iconRadius * 1.3,
      Colors.white,
      opacity,
    );

    // Add highlight on visible icons
    if (depthFactor > 0.7) {
      canvas.drawCircle(
        position + Offset(-iconRadius * 0.3, -iconRadius * 0.3),
        iconRadius * 0.35,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..blendMode = BlendMode.screen,
      );
    }
  }

  void _drawIcon(
    Canvas canvas,
    Offset position,
    IconData iconData,
    double size,
    Color color,
    double opacity,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          color: color.withValues(alpha: opacity),
          fontSize: size,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_SixCategoryLoaderPainter oldDelegate) {
    return oldDelegate.rotationProgress != rotationProgress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}
