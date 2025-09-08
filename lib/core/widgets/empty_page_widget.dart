import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({
    required this.icon,
    this.iconColor = AppTheme.primaryColor,
    this.backgroundColor = AppTheme.primaryColor,
    this.childBelow,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Widget? childBelow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          width: double.infinity,
          height: 20,
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Bigger background with a wavy, soft clipper
              ClipPath(
                clipper: BubbleClipper(),
                child: Container(
                  width: 140,
                  height: 100,
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.15),
                  ),
                ),
              ),
              // Smaller foreground with a tighter, slightly sharper shape
              ClipPath(
                clipper: ForegroundBubbleClipper(),
                child: Container(
                  width: 90,
                  height: 70,
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.3),
                  ),
                  child: Icon(icon, color: iconColor, size: 40),
                ),
              ),
            ],
          ),
        ),
        if (childBelow != null) ...<Widget>[
          const SizedBox(height: 16),
          childBelow!,
        ],
      ],
    );
  }
}

// Background soft bubble clipper (simple oval)
class BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    ));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Foreground soft bubble clipper (smaller simple oval)
class ForegroundBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    ));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
