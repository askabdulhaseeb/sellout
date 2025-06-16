import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/chat/chat_type.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chat_dashboard/domain/entities/chat/participant/chat_participant_entity.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../providers/chat_provider.dart';
import 'message_tile.dart';

class MessagesList extends HookWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatPro = context.watch<ChatProvider>();
    final ScrollController scrollController = useScrollController();
    final ValueNotifier<List<MessageEntity>> messages =
        useState<List<MessageEntity>>(<MessageEntity>[]);

    final String? chatId = chatPro.chat?.chatId;

    useEffect(() {
      if (chatId == null) return null;

      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);

      final GettedMessageEntity? existing = box.get(chatId);
      if (existing != null) {
        messages.value = _prepareMessages(existing, chatPro);
      }

      final StreamSubscription<BoxEvent> subscription =
          box.watch(key: chatId).listen((BoxEvent event) {
        final GettedMessageEntity? updated = box.get(chatId);
        if (updated != null) {
          final List<MessageEntity> newMessages =
              _prepareMessages(updated, chatPro);

          final bool wasNearBottom = scrollController.hasClients &&
              scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent - 50;

          messages.value = newMessages;

          if (wasNearBottom) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        }
      });

      scrollController.addListener(() {
        if (scrollController.position.pixels <=
            scrollController.position.minScrollExtent + 100) {
          chatPro.loadMessages();
        }
      });

      return subscription.cancel;
    }, <Object?>[chatId]);

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      reverse: true,
      itemCount: messages.value.length,
      itemBuilder: (BuildContext context, int index) {
        final MessageEntity current = messages.value[index];
        final MessageEntity? next =
            index > 0 ? messages.value[index - 1] : null;

        return MessageTile(
          key: ValueKey<String>(current.messageId),
          message: current,
          timeDiff: (next != null && current.sendBy == next.sendBy)
              ? current.createdAt.difference(next.createdAt)
              : const Duration(days: 5),
        );
      },
    );
  }

  List<MessageEntity> _prepareMessages(
      GettedMessageEntity entity, ChatProvider chatPro) {
    if (chatPro.chat?.type == ChatType.group) {
      final DateTime? chatAt = _getJoinedAt(chatPro);
      return _filterMessages(entity.sortedMessage(), chatAt);
    } else {
      return entity.sortedMessage();
    }
  }

  DateTime? _getJoinedAt(ChatProvider chatPro) {
    final String userId = LocalAuth.uid ?? '';
    final List<ChatParticipantEntity> participants =
        chatPro.chat?.groupInfo?.participants ?? <ChatParticipantEntity>[];

    for (final ChatParticipantEntity p in participants) {
      if (p.uid == userId) {
        return p.chatAt;
      }
    }
    return null;
  }

  List<MessageEntity> _filterMessages(
      List<MessageEntity> messages, DateTime? chatAt) {
    if (chatAt == null) return <MessageEntity>[];
    return messages
        .where((MessageEntity m) => m.createdAt.isAfter(chatAt))
        .toList();
  }
}
