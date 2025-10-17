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

// class CosmicRotatingLoader extends StatefulWidget {
//   const CosmicRotatingLoader({super.key});

//   @override
//   State<CosmicRotatingLoader> createState() => _CosmicRotatingLoaderState();
// }

// class _CosmicRotatingLoaderState extends State<CosmicRotatingLoader>
//     with TickerProviderStateMixin {
//   late final AnimationController _orbit1;
//   late final AnimationController _orbit2;
//   late final AnimationController _orbit3;
//   late final AnimationController _orbit4;
//   late final AnimationController _orbit5;
//   late final AnimationController _orbit6;

//   @override
//   void initState() {
//     super.initState();
//     _orbit1 =
//         AnimationController(vsync: this, duration: const Duration(seconds: 3))
//           ..repeat();
//     _orbit2 = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 3800))
//       ..repeat(reverse: true);
//     _orbit3 =
//         AnimationController(vsync: this, duration: const Duration(seconds: 4))
//           ..repeat();
//     _orbit4 = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 4500))
//       ..repeat(reverse: true);
//     _orbit5 =
//         AnimationController(vsync: this, duration: const Duration(seconds: 5))
//           ..repeat();
//     _orbit6 = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 5500))
//       ..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _orbit1.dispose();
//     _orbit2.dispose();
//     _orbit3.dispose();
//     _orbit4.dispose();
//     _orbit5.dispose();
//     _orbit6.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         height: 100,
//         width: 100,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: Listenable.merge(
//                   [_orbit1, _orbit2, _orbit3, _orbit4, _orbit5, _orbit6]),
//               builder: (BuildContext context, Widget? child) {
//                 return CustomPaint(
//                   painter: _IndependentOrbitLoaderPainter(
//                     orbit1Progress: _orbit1.value,
//                     orbit2Progress: _orbit2.value,
//                     orbit3Progress: _orbit3.value,
//                     orbit4Progress: _orbit4.value,
//                     orbit5Progress: _orbit5.value,
//                     orbit6Progress: _orbit6.value,
//                     primaryColor: Theme.of(context).primaryColor,
//                     accentColor: Theme.of(context).colorScheme.secondary,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _IndependentOrbitLoaderPainter extends CustomPainter {
//   _IndependentOrbitLoaderPainter({
//     required this.orbit1Progress,
//     required this.orbit2Progress,
//     required this.orbit3Progress,
//     required this.orbit4Progress,
//     required this.orbit5Progress,
//     required this.orbit6Progress,
//     required this.primaryColor,
//     required this.accentColor,
//   });

//   final double orbit1Progress;
//   final double orbit2Progress;
//   final double orbit3Progress;
//   final double orbit4Progress;
//   final double orbit5Progress;
//   final double orbit6Progress;
//   final Color primaryColor;
//   final Color accentColor;

//   static const List<IconData> categoryIcons = [
//     Icons.home,
//     Icons.shopping_bag,
//     Icons.pets,
//     Icons.directions_car,
//     Icons.restaurant,
//     Icons.build,
//   ];

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;

//     // Each icon: own radius, start angle, progress, color, direction
//     final List<Map<String, dynamic>> orbits = [
//       {
//         'radius': 35.0,
//         'startAngle': 0.0,
//         'progress': orbit1Progress,
//         'color': primaryColor,
//         'icon': categoryIcons[0]
//       },
//       {
//         'radius': 38.0,
//         'startAngle': pi / 3,
//         'progress': orbit2Progress,
//         'color': accentColor,
//         'icon': categoryIcons[1]
//       },
//       {
//         'radius': 40.0,
//         'startAngle': 2 * pi / 3,
//         'progress': orbit3Progress,
//         'color': Color.lerp(primaryColor, accentColor, 0.3),
//         'icon': categoryIcons[2]
//       },
//       {
//         'radius': 42.0,
//         'startAngle': pi,
//         'progress': orbit4Progress,
//         'color': Color.lerp(primaryColor, accentColor, 0.5),
//         'icon': categoryIcons[3]
//       },
//       {
//         'radius': 44.0,
//         'startAngle': 4 * pi / 3,
//         'progress': orbit5Progress,
//         'color': Color.lerp(primaryColor, accentColor, 0.7),
//         'icon': categoryIcons[4]
//       },
//       {
//         'radius': 46.0,
//         'startAngle': 5 * pi / 3,
//         'progress': orbit6Progress,
//         'color': accentColor,
//         'icon': categoryIcons[5]
//       },
//     ];

//     for (final orbit in orbits) {
//       final double radius = orbit['radius'] as double;
//       final double startAngle = orbit['startAngle'] as double;
//       final double progress = orbit['progress'] as double;
//       final Color color = orbit['color'] as Color;
//       final IconData icon = orbit['icon'] as IconData;

//       final double angle = startAngle + (progress * 2 * pi);
//       final double x = centerX + radius * cos(angle);
//       final double y = centerY + radius * sin(angle);

//       final double depthFactor = 0.5 + (sin(angle) * 0.5);
//       final double iconSize = 7 + (depthFactor * 2.5);
//       final double opacity = 0.5 + (depthFactor * 0.5);

//       _drawIconOnOrbit(
//           canvas, Offset(x, y), icon, color, iconSize, opacity, depthFactor);
//     }
//   }

//   void _drawIconOnOrbit(Canvas canvas, Offset position, IconData iconData,
//       Color color, double iconSize, double opacity, double depthFactor) {
//     canvas.drawCircle(
//         position,
//         iconSize + 1.5,
//         Paint()
//           ..color = color.withValues(alpha: 0.2 * depthFactor)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
//     canvas.drawCircle(
//         position, iconSize, Paint()..color = color.withValues(alpha: opacity));
//     _drawIcon(
//         canvas, position, iconData, iconSize * 1.2, Colors.white, opacity);
//     if (depthFactor > 0.7) {
//       canvas.drawCircle(
//           position + Offset(-iconSize * 0.35, -iconSize * 0.35),
//           iconSize * 0.3,
//           Paint()
//             ..color = Colors.white.withValues(alpha: 0.4)
//             ..blendMode = BlendMode.screen);
//     }
//   }

//   void _drawIcon(Canvas canvas, Offset position, IconData iconData, double size,
//       Color color, double opacity) {
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: String.fromCharCode(iconData.codePoint),
//         style: TextStyle(
//             color: color.withValues(alpha: opacity),
//             fontSize: size,
//             fontFamily: iconData.fontFamily,
//             package: iconData.fontPackage),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout();
//     textPainter.paint(canvas,
//         position - Offset(textPainter.width / 2, textPainter.height / 2));
//   }

//   @override
//   bool shouldRepaint(_IndependentOrbitLoaderPainter oldDelegate) {
//     return oldDelegate.orbit1Progress != orbit1Progress ||
//         oldDelegate.orbit2Progress != orbit2Progress ||
//         oldDelegate.orbit3Progress != orbit3Progress ||
//         oldDelegate.orbit4Progress != orbit4Progress ||
//         oldDelegate.orbit5Progress != orbit5Progress ||
//         oldDelegate.orbit6Progress != orbit6Progress ||
//         oldDelegate.primaryColor != primaryColor ||
//         oldDelegate.accentColor != accentColor;
//   }
// }
