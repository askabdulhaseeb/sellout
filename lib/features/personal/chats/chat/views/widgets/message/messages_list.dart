import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_string.dart';
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

      // Initial load
      final GettedMessageEntity? existing = box.get(chatId);
      if (existing != null) {
        messages.value = <MessageEntity>[...existing.sortedByNewestFirst()];
      }

      final StreamSubscription<BoxEvent> subscription =
          box.watch(key: chatId).listen((BoxEvent event) {
        final GettedMessageEntity? updated = box.get(chatId);
        if (updated != null) {
          final List<MessageEntity> newMessages = updated.sortedByNewestFirst();
          final List<MessageEntity> previousMessages = messages.value;

          if (!_areListsEqual(previousMessages, newMessages)) {
            final bool wasNearBottom = scrollController.hasClients &&
                scrollController.position.pixels >=
                    scrollController.position.maxScrollExtent - 50;

            messages.value = newMessages;

            if (wasNearBottom) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
          }
        }
      });

      return subscription.cancel;
    }, <Object?>[chatId]);

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        reverse: true, // Keep reverse true for bottom alignment
        itemCount: messages.value.length,
        itemBuilder: (BuildContext context, int index) {
          // Direct index access with proper sorting
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
      ),
    );
  }

  bool _areListsEqual(List<MessageEntity> a, List<MessageEntity> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].messageId != b[i].messageId) return false;
    }
    return true;
  }
}

extension SortedMessages on GettedMessageEntity {
  List<MessageEntity> sortedByNewestFirst() {
    final List<MessageEntity> copy = <MessageEntity>[
      ...this.messages
    ]; // use this.messages
    copy.sort((MessageEntity a, MessageEntity b) =>
        b.createdAt.compareTo(a.createdAt));
    return copy;
  }
}
