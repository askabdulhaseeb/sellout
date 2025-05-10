import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../chat/domain/entities/getted_message_entity.dart';
import '../../domain/entities/chat/chat_entity.dart';

class UnseenMessageBadge extends StatelessWidget {
  const UnseenMessageBadge({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<GettedMessageEntity>>(
      valueListenable:
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox)
              .listenable(),
      builder: (BuildContext context, Box<GettedMessageEntity> box, _) {
        final int unseenCount = SeenMessageCounter.getUnseenCount(chat.chatId);

        if (unseenCount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            unseenCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

class SeenMessageCounter {
  static final Map<String, int> _unseenMap = <String, int>{};

  static void newMessageReceived(String chatId) {
    _unseenMap[chatId] = (_unseenMap[chatId] ?? 0) + 1;
  }

  static int getUnseenCount(String chatId) {
    return _unseenMap[chatId] ?? 0;
  }

  static void reset(String chatId) {
    _unseenMap[chatId] = 0;
  }
}
