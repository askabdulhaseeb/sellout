import 'package:flutter/material.dart';

class UnseenMessageBadge extends StatelessWidget {
  final int unreadCount;
  final dynamic chat; // keep your existing chat param if needed

  const UnseenMessageBadge({
    Key? key,
    required this.unreadCount,
    this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (unreadCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      child: Text(
        unreadCount > 99 ? '99+' : unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
