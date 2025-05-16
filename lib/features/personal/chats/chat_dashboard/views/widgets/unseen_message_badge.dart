import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../chat/domain/entities/getted_message_entity.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/entities/chat/participant/chat_participant_entity.dart';
import '../../domain/entities/messages/message_entity.dart';

class UnseenMessageBadge extends HookWidget {
  const UnseenMessageBadge({
    required this.chat,
    super.key,
  });

  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final Box<GettedMessageEntity> messageBox = useMemoized(
        () => Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox));

    // Automatically manages stream subscription
    useStream(useMemoized(() => messageBox.watch()));

    final int unreadCount = _calculateUnreadCount(messageBox);

    if (unreadCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
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

  int _calculateUnreadCount(Box<GettedMessageEntity> messageBox) {
    final String? currentUserId = LocalAuth.currentUser?.userID;
    if (currentUserId == null) return 0;

    final ChatParticipantEntity? participant =
        chat.participants?.cast<ChatParticipantEntity?>().firstWhere(
              (ChatParticipantEntity? p) => p?.uid == currentUserId,
              orElse: () => null,
            );

    final DateTime lastReadAt = participant?.chatAt ?? DateTime(1970);

    // 👇 Print the last seen/read time
    print('User last read chat at: $lastReadAt');

    final GettedMessageEntity? storedMessage = messageBox.get(chat.chatId);
    final List<MessageEntity> messages =
        storedMessage?.messages ?? <MessageEntity>[];

    if (messages.isEmpty) return 0;

    messages.sort((MessageEntity a, MessageEntity b) =>
        a.createdAt.compareTo(b.createdAt));
    int low = 0, high = messages.length;

    while (low < high) {
      final int mid = (low + high) ~/ 2;
      messages[mid].createdAt.isAfter(lastReadAt) ? high = mid : low = mid + 1;
    }

    return messages.length - low;
  }
}
