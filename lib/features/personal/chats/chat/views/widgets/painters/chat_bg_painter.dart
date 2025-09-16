import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ChatBgPainter extends CustomPainter {
  ChatBgPainter({
    required this.baseColor,
    required this.accentColor,
    required this.tileSize,
  });

  final Color baseColor;
  final Color accentColor;
  final double tileSize;
  final Random _rnd = Random();

  @override
  void paint(Canvas canvas, Size size) {
    // Paint background
    final ui.Paint paint = Paint()..color = baseColor;
    canvas.drawRect(Offset.zero & size, paint);

    // Soft noise overlay
    _drawSubtleNoise(canvas, size);

    final int rows = (size.height / tileSize).ceil() + 1;
    final int cols = (size.width / tileSize).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double dx = c * tileSize + (_rnd.nextDouble() * 15 - 7);
        final double dy = r * tileSize + (_rnd.nextDouble() * 15 - 7);

        final int variant = _rnd.nextInt(5); // 5 icons
        final double scale = 0.8 + (_rnd.nextDouble() * 0.3);
        final double opacity = 0.18 + (_rnd.nextDouble() * 0.2);

        canvas.save();
        final double angle = (_rnd.nextDouble() - 0.5) * 0.25;
        canvas.translate(dx, dy);
        canvas.rotate(angle);

        final ui.Color color = accentColor.withOpacity(opacity);

        switch (variant) {
          case 0:
            _drawTicket(canvas, scale, color);
            break;
          case 1:
            _drawCalendar(canvas, scale, color);
            break;
          case 2:
            _drawTool(canvas, scale, color);
            break;
          case 3:
            _drawHouse(canvas, scale, color);
            break;
          case 4:
            _drawSellOut(canvas, scale, color);
            break;
          default:
            _drawChatBubble(canvas, scale, color);
        }

        canvas.restore();
      }
    }
  }

  void _drawSubtleNoise(Canvas canvas, Size size) {
    final ui.Paint noisePaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..blendMode = ui.BlendMode.overlay;
    const double step = 40.0;
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        canvas.drawRect(Rect.fromLTWH(x, y, step, step), noisePaint);
      }
    }
  }

  void _drawTicket(Canvas canvas, double scale, Color color) {
    final ui.Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;

    final double w = 40 * scale;
    final double h = 20 * scale;
    final double r = 5 * scale;

    final ui.Path path = Path();
    // base rect
    path.addRRect(
        RRect.fromLTRBR(-w / 2, -h / 2, w / 2, h / 2, Radius.circular(r)));
    // perforation holes
    path.moveTo(-w / 4, -h / 2);
    path.lineTo(-w / 4, h / 2);
    path.moveTo(w / 4, -h / 2);
    path.lineTo(w / 4, h / 2);

    canvas.drawPath(path, paint);
  }

  void _drawCalendar(Canvas canvas, double scale, Color color) {
    final ui.Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;

    final double w = 30 * scale;
    final double h = 30 * scale;
    final double r = 4 * scale;

    final ui.Path path = Path();
    path.addRRect(
        RRect.fromLTRBR(-w / 2, -h / 2, w / 2, h / 2, Radius.circular(r)));

    // calendar header
    path.moveTo(-w / 2, -h / 6);
    path.lineTo(w / 2, -h / 6);

    // vertical date lines
    path.moveTo(-w / 6, -h / 6);
    path.lineTo(-w / 6, h / 2);
    path.moveTo(w / 6, -h / 6);
    path.lineTo(w / 6, h / 2);

    canvas.drawPath(path, paint);
  }

  void _drawTool(Canvas canvas, double scale, Color color) {
    final ui.Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;

    // simple wrench-like shape
    final ui.Path path = Path();
    path.moveTo(-10 * scale, 0);
    path.lineTo(0, -10 * scale);
    path.lineTo(10 * scale, 0);
    path.lineTo(0, 10 * scale);
    path.close();
    canvas.drawPath(path, paint);

    // handle
    canvas.drawLine(Offset(0, 10 * scale), Offset(0, 20 * scale), paint);
  }

  void _drawHouse(Canvas canvas, double scale, Color color) {
    final ui.Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;

    // base square
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(0, 5 * scale),
            width: 20 * scale,
            height: 15 * scale),
        paint);

    // roof
    final ui.Path path = Path();
    path.moveTo(-12 * scale, 0);
    path.lineTo(0, -12 * scale);
    path.lineTo(12 * scale, 0);
    canvas.drawPath(path, paint);
  }

  void _drawSellOut(Canvas canvas, double scale, Color color) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'sellout',
        style: TextStyle(
          fontSize: 16 * scale,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1.5 * scale,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  void _drawChatBubble(Canvas canvas, double scale, Color color) {
    final ui.Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    final double w = 44 * scale;
    final double h = 34 * scale;
    final double r = 6 * scale;
    final ui.Path path = Path();
    path.addRRect(
        RRect.fromLTRBR(-w / 2, -h / 2, w / 2, h / 2, Radius.circular(r)));
    path.moveTo(-w / 4, h / 2 - 2 * scale);
    path.lineTo(-w / 4 - 6 * scale, h / 2 + 8 * scale);
    path.lineTo(-w / 4 + 8 * scale, h / 2 - 2 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ChatBgPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.tileSize != tileSize;
  }
}
