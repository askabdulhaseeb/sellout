import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../helpers/date_label_helper.dart';
import '../../providers/chat_provider.dart';

class MessagesList extends HookWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final ScrollController scrollController = useScrollController();
    final ValueNotifier<List<MessageEntity>> messages =
        useState(<MessageEntity>[]);
    final ValueNotifier<bool> isAtBottom = useState(false);
    final ObjectRef<int> prevMsgCountRef = useRef(0);
    final String? chatId = chatProvider.chat?.chatId;

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

    final List<Widget> messageWidgets = useMemoized(
      () => DateLabelHelper.buildLabeledWidgets(messages.value, timeDiffMap),
      <Object?>[messages.value, timeDiffMap],
    );

    // Track bottom status
    useEffect(() {
      void listener() {
        isAtBottom.value = scrollController.position.pixels <= 50;
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, <Object?>[]);

    // Initial load
    useEffect(() {
      if (chatId == null) {
        messages.value = <MessageEntity>[];
        return null;
      }
      final Box<GettedMessageEntity> box =
          Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
      final GettedMessageEntity? stored = box.get(chatId);

      Future<void>.microtask(() {
        if (stored != null) {
          messages.value = chatProvider.getFilteredMessages(stored);
          prevMsgCountRef.value = messages.value.length;
        }
      });

      final StreamSubscription<BoxEvent> sub =
          box.watch(key: chatId).listen((_) {
        chatProvider.handleMessagesUpdate(
          box,
          chatId,
          chatProvider,
          messages,
          scrollController,
        );
      });
      return sub.cancel;
    }, <Object?>[chatId]);

    // Auto-scroll new messages
    useEffect(() {
      if (messages.value.length > prevMsgCountRef.value &&
          isAtBottom.value &&
          scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            0.0, // since reverse:true, 0.0 is the bottom
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
      prevMsgCountRef.value = messages.value.length;

      return null;
    }, <Object?>[messages.value]);

    // Pagination (load older messages when reaching top — reversed view!)
    useEffect(() {
      void listener() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 50) {
          chatProvider.loadMessages();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, <Object?>[]);
    return messages.value.isEmpty
        ? Center(child: Text('no_messages_yet'.tr()))
        : ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            reverse: true, // <-- this will start from bottom
            itemCount: messageWidgets.length,
            itemBuilder: (_, int i) => messageWidgets.reversed.toList()[i],
          );
  }
}
