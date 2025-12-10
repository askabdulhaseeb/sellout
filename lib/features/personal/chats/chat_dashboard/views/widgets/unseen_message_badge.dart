import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../../core/utilities/app_string.dart';
import '../../domain/entities/chat/unread_message_entity.dart';

class UnreadMessageBadgeWidget extends StatelessWidget {
  const UnreadMessageBadgeWidget({required this.chatId, super.key});
  final String chatId;

  @override
  Widget build(BuildContext context) {
    final Box<UnreadMessageEntity> unreadCountBox =
        Hive.box<UnreadMessageEntity>(AppStrings.localUnreadMessages);

    return ValueListenableBuilder<Box<UnreadMessageEntity>>(
      valueListenable: unreadCountBox.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<UnreadMessageEntity> box, _) {
        final int count = box.get(chatId)?.count ?? 0;
        if (count == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          alignment: Alignment.center,
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

class TotalUnreadMessagesBadgeWidget extends StatelessWidget {
  const TotalUnreadMessagesBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<UnreadMessageEntity> unreadBox = Hive.box<UnreadMessageEntity>(
      AppStrings.localUnreadMessages,
    );
    return ValueListenableBuilder<Box<UnreadMessageEntity>>(
      valueListenable: unreadBox.listenable(),
      builder: (BuildContext context, Box<UnreadMessageEntity> box, _) {
        int totalCount = 0;
        for (final UnreadMessageEntity entry in box.values) {
          totalCount += entry.count;
        }
        if (totalCount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          alignment: Alignment.center,
          child: Text(
            totalCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
