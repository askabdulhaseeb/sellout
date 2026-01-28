import 'dart:math';
import 'package:flutter/material.dart';

class AccountWarningBanner extends StatelessWidget {
  const AccountWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFC41C3B), Color(0xFFB01832)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Decorative Background Pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(painter: _DecorationPatternPainter()),
            ),
          ),
          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icon Section
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  children: <Widget>[
                    const Icon(
                      Icons.shield_outlined,
                      size: 32,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.warning_rounded,
                          size: 12,
                          color: Color(0xFFC41C3B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Account Deactivation & Deletion',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Need a break or want to leave? You can temporarily deactivate your account or permanently delete it. Choose an option below to proceed.',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Decoration Pattern Painter for the warning banner
class _DecorationPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Paint circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw decorative stars and circles across the banner
    _drawStar(canvas, const Offset(20, 15), 8, starPaint);
    _drawStar(canvas, Offset(size.width - 30, 25), 10, starPaint);
    _drawStar(canvas, Offset(size.width - 20, size.height - 20), 8, starPaint);
    _drawStar(canvas, Offset(40, size.height - 15), 9, starPaint);
    _drawStar(canvas, Offset(size.width / 2 - 30, 10), 7, starPaint);

    // Circles scattered
    canvas.drawCircle(const Offset(30, 40), 4, circlePaint);
    canvas.drawCircle(Offset(size.width - 40, 50), 5, circlePaint);
    canvas.drawCircle(
      Offset(size.width - 15, size.height - 30),
      3,
      circlePaint,
    );
    canvas.drawCircle(Offset(25, size.height - 25), 4, circlePaint);
    canvas.drawCircle(Offset(size.width / 2, 20), 3, circlePaint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      final double angle = (i * 4 * pi) / 5 - pi / 2;
      final double x = center.dx + size * cos(angle);
      final double y = center.dy + size * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DecorationPatternPainter oldDelegate) => false;
}
