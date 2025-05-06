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
    final ObjectRef<Set<String>> shownMessageIds =
        useRef<Set<String>>(<String>{});
    final String? chatId = chatPro.chat?.chatId;
    useEffect(() {
      if (chatId == null) return null;
      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
      final StreamSubscription<BoxEvent> subscription =
          box.watch(key: chatId).listen((BoxEvent event) {
        final GettedMessageEntity? updated = box.get(chatId);
        final List<MessageEntity> newMessages =
            updated?.sortedMessage() ?? <MessageEntity>[];
        for (final MessageEntity message in newMessages) {
          if (!shownMessageIds.value.contains(message.messageId)) {
            shownMessageIds.value.add(message.messageId);
            messages.value = <MessageEntity>[message, ...messages.value];

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
      return subscription.cancel;
    }, <Object?>[chatId]);
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        reverse: true,
        itemCount: messages.value.length,
        itemBuilder: (BuildContext context, int index) {
          final MessageEntity current = messages.value[index];
          final MessageEntity? next = index < messages.value.length - 1
              ? messages.value[index + 1]
              : null;
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
}

class AnimatedMessageTile extends StatelessWidget {
  const AnimatedMessageTile({
    required this.message,
    required this.nextMessage,
    required this.animate,
    super.key,
  });
  final MessageEntity message;
  final MessageEntity? nextMessage;
  final bool animate;

  Duration get _timeDiff {
    return (nextMessage != null && message.sendBy == nextMessage!.sendBy)
        ? message.createdAt.difference(nextMessage!.createdAt)
        : const Duration(days: 5);
  }

  @override
  Widget build(BuildContext context) {
    final MessageTile tile = MessageTile(
      key: ValueKey(message.messageId),
      message: message,
      timeDiff: _timeDiff,
    );

    if (!animate) return tile;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: tile,
    );
  }
}
