import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../helpers/date_label_helper.dart';
import '../../providers/chat_provider.dart';
import '../../providers/send_message_provider.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({required this.chat, required this.controller, super.key});
  final ChatEntity? chat;
  final ScrollController controller;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  int _previousMessageCount = 0;
  List<Widget> _cachedWidgets = <Widget>[];
  String? _lastMessageHash;
  bool _hasInitiallyScrolled = false;

  void _jumpToBottom() {
    if (widget.controller.hasClients) {
      widget.controller.jumpTo(widget.controller.position.maxScrollExtent);
    }
  }

  void _scheduleInitialScroll() {
    if (_hasInitiallyScrolled) return;
    _hasInitiallyScrolled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToBottom();
    });
  }

  void _scrollToBottomIfNeeded() {
    if (!widget.controller.hasClients) return;
    final double current = widget.controller.position.pixels;
    final double bottom = widget.controller.position.maxScrollExtent;

    if (bottom - current < 100) {
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        if (widget.controller.hasClients) {
          widget.controller.animateTo(
            widget.controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onMessagesChanged(int newCount) {
    if (newCount > _previousMessageCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomIfNeeded();
      });
    }
    _previousMessageCount = newCount;
  }

  String _generateMessageHash(List<MessageEntity> messages) {
    if (messages.isEmpty) return '';
    final StringBuffer buffer = StringBuffer();
    for (final MessageEntity m in messages) {
      // Include file info for audio/document messages that update after upload
      final String fileHash = m.fileUrl.isNotEmpty
          ? '${m.fileUrl.length}:${m.fileUrl.map((AttachmentEntity f) => f.url).join(",")}'
          : '';
      buffer.write(
        '${m.messageId}:${m.updatedAt.millisecondsSinceEpoch}:${m.status?.code ?? ""}:${m.fileStatus ?? ""}:$fileHash|',
      );
    }
    return buffer.toString();
  }

  List<Widget> _buildWidgetsIfNeeded(List<MessageEntity> messages) {
    final String currentHash = _generateMessageHash(messages);
    if (currentHash != _lastMessageHash) {
      _lastMessageHash = currentHash;
      final Map<String, Duration> timeDiffMap = <String, Duration>{};
      for (int i = 0; i < messages.length; i++) {
        final MessageEntity current = messages[i];
        final MessageEntity? next = i < messages.length - 1
            ? messages[i + 1]
            : null;
        final Duration diff = (next != null && current.sendBy == next.sendBy)
            ? next.createdAt.difference(current.createdAt).abs()
            : const Duration(days: 5);
        timeDiffMap[current.messageId] = diff;
      }

      _cachedWidgets = DateLabelHelper.buildLabeledWidgets(
        messages,
        timeDiffMap,
      );
    }

    return _cachedWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final SendMessageProvider sendMessageProvider = context
        .watch<SendMessageProvider>();
    final String? chatId = chatProvider.chat?.chatId;
    final bool isLoading = chatProvider.isLoading;

    if (chatId == null) {
      return Expanded(
        child: SingleChildScrollView(
          child: EmptyPageWidget(
            icon: CupertinoIcons.chat_bubble_2,
            childBelow: const Text('no_messages_yet').tr(),
          ),
        ),
      );
    }
    final Box<GettedMessageEntity> box = Hive.box<GettedMessageEntity>(
      AppStrings.localChatMessagesBox,
    );

    return ValueListenableBuilder<Box<GettedMessageEntity>>(
      valueListenable: box.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<GettedMessageEntity> box, _) {
        // Also listen to pending messages for optimistic UI
        return ValueListenableBuilder<List<MessageEntity>>(
          valueListenable: sendMessageProvider.pendingMessages,
          builder: (BuildContext context, List<MessageEntity> pending, _) {
            final GettedMessageEntity? stored = box.get(chatId);
            final List<MessageEntity> storedMessages = stored == null
                ? <MessageEntity>[]
                : chatProvider.getFilteredMessages(stored);
            // Combine stored messages with pending messages
            final List<MessageEntity> messages = <MessageEntity>[
              ...storedMessages,
              ...pending.where((MessageEntity p) => p.chatId == chatId),
            ];
            // Show loading indicator when loading and no messages yet
            if (isLoading && messages.isEmpty) {
              return const Expanded(
                child: Center(child: CupertinoActivityIndicator()),
              );
            }
            // Show empty state when not loading and no messages
            if (!isLoading && messages.isEmpty) {
              return Expanded(
                child: SingleChildScrollView(
                  child: EmptyPageWidget(
                    icon: CupertinoIcons.chat_bubble_2,
                    childBelow: const Text('no_messages_yet').tr(),
                  ),
                ),
              );
            }
            // Prefetch sender names for performance (runs async, doesn't block)
            chatProvider.prefetchSenderNames(messages);
            // Build widgets only when messages change (cached)
            final List<Widget> widgets = _buildWidgetsIfNeeded(messages);
            // Scroll to bottom on initial load
            _scheduleInitialScroll();
            // Scroll when new messages arrive (only triggers when count increases)
            _onMessagesChanged(messages.length);

            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                cacheExtent: 500,
                controller: widget.controller,
                itemCount: widgets.length,
                itemBuilder: (BuildContext context, int index) {
                  return widgets[index];
                },
              ),
            );
          },
        );
      },
    );
  }
}
