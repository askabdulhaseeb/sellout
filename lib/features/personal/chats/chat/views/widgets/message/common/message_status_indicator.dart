import 'package:flutter/material.dart';
import '../../../../../../../../core/enums/message/message_status.dart';

/// Displays message delivery status (sent, delivered, read) with checkmark icons.
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
        return Icon(
          Icons.access_time,
          size: size,
          color: defaultColor,
        );
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
