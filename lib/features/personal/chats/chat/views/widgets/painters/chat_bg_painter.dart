import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class TileData {
  TileData({
    required this.dx,
    required this.dy,
    this.opacity = 0.2,
    this.type = 0,
  });

  final double dx;
  final double dy;
  final double opacity;
  final int type; // 0 = outline, 1 = filled, 2 = stripes, 3 = dot
}

/// Make a grid with a fixed number of columns.
List<TileData> generateBentoTilesFixedColumns(Size size, int columns) {
  final double tileSize = size.width / columns;
  final int rows = (size.height / tileSize).ceil() + 1;

  final math.Random rnd = math.Random();
  final List<TileData> tiles = <TileData>[];
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < columns; c++) {
      tiles.add(TileData(
        dx: c * tileSize + tileSize / 2,
        dy: r * tileSize + tileSize / 2,
        opacity: (r + c) % 2 == 0 ? 0.18 : 0.3,
        type: rnd.nextInt(4), // pick random tile style
      ));
    }
  }
  return tiles;
}

/// 1️⃣ Outline squircle
class FancyOutlineTilePainter extends CustomPainter {
  FancyOutlineTilePainter({
    required this.color,
    required this.tileSize,
    required this.opacity,
  });
  final Color color;
  final double tileSize;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = tileSize * 0.7;
    final double h = tileSize * 0.7;
    final double corner = tileSize * 0.18;

    final Path path = Path()
      ..moveTo(-w / 2 + corner, -h / 2)
      ..lineTo(w / 2 - corner, -h / 2)
      ..quadraticBezierTo(w / 2, -h / 2, w / 2, -h / 2 + corner)
      ..lineTo(w / 2, h / 2 - corner)
      ..quadraticBezierTo(w / 2, h / 2, w / 2 - corner, h / 2)
      ..lineTo(-w / 2 + corner, h / 2)
      ..quadraticBezierTo(-w / 2, h / 2, -w / 2, h / 2 - corner)
      ..lineTo(-w / 2, -h / 2 + corner)
      ..quadraticBezierTo(-w / 2, -h / 2, -w / 2 + corner, -h / 2)
      ..close();

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.save();
    canvas.translate(2, 2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    final Paint outlinePaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant FancyOutlineTilePainter old) => false;
}

/// 2️⃣ Filled rounded tile with gradient
class FilledRoundedTilePainter extends CustomPainter {
  FilledRoundedTilePainter({
    required this.color,
    required this.tileSize,
    required this.opacity,
  });
  final Color color;
  final double tileSize;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCenter(
      center: Offset.zero,
      width: tileSize * 0.6,
      height: tileSize * 0.6,
    );
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(tileSize * 0.15),
    );
    final Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        rect.topLeft,
        rect.bottomRight,
        <Color>[
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.5),
        ],
      );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant FilledRoundedTilePainter old) => false;
}

/// 3️⃣ Diagonal stripes tile
class DiagonalStripeTilePainter extends CustomPainter {
  DiagonalStripeTilePainter({
    required this.color,
    required this.tileSize,
    required this.opacity,
  });
  final Color color;
  final double tileSize;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = tileSize * 0.6;
    final Rect rect = Rect.fromCenter(center: Offset.zero, width: s, height: s);
    final Paint bg = Paint()..color = color.withValues(alpha: opacity * 0.2);
    canvas.drawRect(rect, bg);

    final Paint linePaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = 2.0;
    for (double i = -s; i < s; i += 8) {
      canvas.drawLine(Offset(i, -s), Offset(i + s, s), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant DiagonalStripeTilePainter old) => false;
}

/// 4️⃣ Circle dot tile
class CircleDotTilePainter extends CustomPainter {
  CircleDotTilePainter({
    required this.color,
    required this.tileSize,
    required this.opacity,
  });
  final Color color;
  final double tileSize;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final double r = tileSize * 0.2;
    final Paint glow = Paint()
      ..color = color.withValues(alpha: opacity * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final Paint dot = Paint()..color = color.withValues(alpha: opacity);

    canvas.drawCircle(Offset.zero, r * 1.5, glow);
    canvas.drawCircle(Offset.zero, r, dot);
  }

  @override
  bool shouldRepaint(covariant CircleDotTilePainter old) => false;
}

/// Background painter
class ChatBgPainter extends CustomPainter {
  ChatBgPainter({
    required this.baseColor,
    required this.accentColor,
    required this.tileSize,
    required this.tiles,
  });
  final Color baseColor;
  final Color accentColor;
  final double tileSize;
  final List<TileData> tiles;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bg = Paint()..color = baseColor;
    canvas.drawRect(Offset.zero & size, bg);

    for (final TileData t in tiles) {
      canvas.save();
      canvas.translate(t.dx, t.dy);
      switch (t.type) {
        case 0:
          FancyOutlineTilePainter(
            color: accentColor,
            tileSize: tileSize,
            opacity: t.opacity,
          ).paint(canvas, Size(tileSize, tileSize));
          break;
        case 1:
          FilledRoundedTilePainter(
            color: accentColor,
            tileSize: tileSize,
            opacity: t.opacity,
          ).paint(canvas, Size(tileSize, tileSize));
          break;
        case 2:
          DiagonalStripeTilePainter(
            color: accentColor,
            tileSize: tileSize,
            opacity: t.opacity,
          ).paint(canvas, Size(tileSize, tileSize));
          break;
        case 3:
          CircleDotTilePainter(
            color: accentColor,
            tileSize: tileSize,
            opacity: t.opacity,
          ).paint(canvas, Size(tileSize, tileSize));
          break;
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ChatBgPainter old) => false;
}

class ChatBackground extends StatelessWidget {
  const ChatBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final List<TileData> tiles = generateBentoTilesFixedColumns(size, 25);
    return CustomPaint(
      size: size,
      painter: ChatBgPainter(
        baseColor: Theme.of(context).dividerColor,
        accentColor: colors.outlineVariant,
        tileSize: size.width / 25,
        tiles: tiles,
      ),
    );
  }
}
