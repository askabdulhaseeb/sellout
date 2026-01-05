import 'package:flutter/material.dart';
import '../../../../../../../../core/enums/message/message_status.dart';

/// Displays message delivery status (sent, delivered, read) with icons.
/// Uses Instagram-style sending arrow for pending messages.
/// Only shows for outgoing messages (isMe = true).
class MessageStatusIndicator extends StatelessWidget {
  const MessageStatusIndicator({
    required this.status,
    required this.isMe,
    this.size = 14,
    this.color,
    this.readColor,
    super.key,
  });

  final MessageStatus status;
  final bool isMe;
  final double size;

  /// Color for pending/sent/delivered states
  final Color? color;

  /// Color for read state (typically blue)
  final Color? readColor;

  @override
  Widget build(BuildContext context) {
    // Only show status for outgoing messages
    if (!isMe) return const SizedBox.shrink();

    final Color defaultColor =
        color ?? Theme.of(context).colorScheme.outline;
    final Color readIndicatorColor =
        readColor ?? Theme.of(context).colorScheme.primary;

    switch (status) {
      case MessageStatus.pending:
        // Instagram-style sending arrow (rotated send icon)
        return _SendingArrow(size: size, color: defaultColor);
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: size,
          color: defaultColor,
        );
      case MessageStatus.delivered:
        return _DoubleCheck(
          size: size,
          color: defaultColor,
        );
      case MessageStatus.read:
        return _DoubleCheck(
          size: size,
          color: readIndicatorColor,
        );
      case MessageStatus.failed:
        return Icon(
          Icons.error_outline,
          size: size,
          color: Theme.of(context).colorScheme.error,
        );
    }
  }
}

/// Instagram-style sending arrow indicator (hollow circle with arrow pointing up-right)
class _SendingArrow extends StatelessWidget {
  const _SendingArrow({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _SendingArrowPainter(color: color),
      ),
    );
  }
}

/// Custom painter for the Instagram-style sending arrow
class _SendingArrowPainter extends CustomPainter {
  _SendingArrowPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 1;

    // Draw hollow circle
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Draw arrow pointing up-right (like Instagram's send arrow)
    final double arrowSize = size.width * 0.35;
    final double arrowCenterX = centerX;
    final double arrowCenterY = centerY;

    // Arrow stem (diagonal line going up-right)
    final Path arrowPath = Path();

    // Start from bottom-left, go to top-right
    arrowPath.moveTo(
      arrowCenterX - arrowSize * 0.5,
      arrowCenterY + arrowSize * 0.5,
    );
    arrowPath.lineTo(
      arrowCenterX + arrowSize * 0.5,
      arrowCenterY - arrowSize * 0.5,
    );

    // Arrow head (two small lines from the tip)
    // Horizontal part of arrowhead
    arrowPath.moveTo(
      arrowCenterX + arrowSize * 0.5,
      arrowCenterY - arrowSize * 0.5,
    );
    arrowPath.lineTo(
      arrowCenterX,
      arrowCenterY - arrowSize * 0.5,
    );

    // Vertical part of arrowhead
    arrowPath.moveTo(
      arrowCenterX + arrowSize * 0.5,
      arrowCenterY - arrowSize * 0.5,
    );
    arrowPath.lineTo(
      arrowCenterX + arrowSize * 0.5,
      arrowCenterY,
    );

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Double checkmark icon for delivered/read states
class _DoubleCheck extends StatelessWidget {
  const _DoubleCheck({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.4,
      height: size,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            child: Icon(Icons.check, size: size, color: color),
          ),
          Positioned(
            left: size * 0.4,
            child: Icon(Icons.check, size: size, color: color),
          ),
        ],
      ),
    );
  }
}
