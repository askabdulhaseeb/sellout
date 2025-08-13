import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../helpers/date_label_helper.dart';
import '../../providers/chat_provider.dart';

class MessagesList extends HookWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final ScrollController scrollController =
        useScrollController(keepScrollOffset: true);
    final ValueNotifier<List<MessageEntity>> messages =
        useState<List<MessageEntity>>(<MessageEntity>[]);
    final String? chatId = chatProvider.chat?.chatId;
    final String? myUserId = LocalAuth.currentUser?.userID;

    // Calculate time differences
    final Map<String, Duration> timeDiffMap = useMemoized(() {
      final Map<String, Duration> map = <String, Duration>{};
      final List<MessageEntity> list = messages.value;
      if (list.isEmpty) return map;

      for (int i = 0; i < list.length; i++) {
        final MessageEntity current = list[i];
        final MessageEntity? next = i < list.length - 1 ? list[i + 1] : null;
        final Duration diff = (next != null && current.sendBy == next.sendBy)
            ? next.createdAt.difference(current.createdAt).abs()
            : const Duration(days: 5);
        map[current.messageId] = diff;
      }
      return map;
    }, <Object?>[messages.value]);
    // Build message widgets (optimized reversal)
    final List<Widget> messageWidgets = useMemoized(
      () {
        final List<Widget> widgets = DateLabelHelper.buildLabeledWidgets(
          messages.value,
          timeDiffMap,
        );
        return widgets.reversed.toList();
      },
      <Object?>[messages.value, timeDiffMap],
    );

    // Handle message updates and scroll position
    useEffect(() {
      if (chatId == null) {
        messages.value = <MessageEntity>[];
        return null;
      }

      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
      final GettedMessageEntity? stored = box.get(chatId);

      Future.microtask(() {
        if (stored != null) {
          messages.value = chatProvider.getFilteredMessages(stored);
        }
      });

      final StreamSubscription<BoxEvent> sub =
          box.watch(key: chatId).listen((_) {
        // Update messages
        chatProvider.handleMessagesUpdate(
          box,
          chatId,
          chatProvider,
          messages,
          scrollController,
        );

        // Wait for next frame to ensure UI is updated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (messages.value.isEmpty)
            return; // Prevent calling .last on empty list

          final bool isMyMessage = messages.value.last.sendBy == myUserId;
          if (!scrollController.hasClients) return;

          if (isMyMessage) {
            scrollController.jumpTo(scrollController.position.minScrollExtent);
          } else {
            // For others' messages, maintain relative position
            // final double newPosition =
            //     scrollPositionState.value.offset + contentHeightDelta;
            // scrollController.jumpTo(
            //     newPosition.clamp(newMinScrollExtent, newMaxScrollExtent));
          }
        });
      });

      return sub.cancel;
    }, <Object?>[chatId]);

    // Pagination at top
    useEffect(() {
      void listener() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          chatProvider.loadMessages();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, <Object?>[]);

    return messages.value.isEmpty
        ? Center(child: Text('no_messages_yet'.tr()))
        : ListView.builder(
            key: const PageStorageKey<String>(
                'chat_messages_list'), // <— add this
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            reverse: true,
            itemCount: messageWidgets.length,
            itemBuilder: (_, int i) => messageWidgets[i],
          );
  }
}
