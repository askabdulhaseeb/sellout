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
import '../../../domain/entities/message_group_entity.dart';
import '../../helpers/message_grouper.dart';
import '../../providers/chat_provider.dart';
import '../../providers/send_message_provider.dart';
import 'message_tile.dart';
import 'message_time_divider.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({required this.chat, required this.controller, super.key});
  final ChatEntity? chat;
  final ScrollController controller;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  int _previousMessageCount = 0;
  final bool _hasInitiallyScrolled = false;
  bool _isLoadingMore = false;

  // Cached data for efficient rebuilds
  final MessageGrouper _grouper = MessageGrouper();
  String? _lastMessageHash;
  GroupedMessages? _cachedGroupedMessages;
  Map<String, Duration>? _cachedTimeDiffs;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  /// Handles scroll events for pagination
  void _onScroll() {
    if (!widget.controller.hasClients) return;

    // Load more when user scrolls near the top (older messages)
    // In a non-reversed list, older messages are at the top
    if (widget.controller.position.pixels <= 200 && !_isLoadingMore) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore) return;

    final ChatProvider chatProvider = context.read<ChatProvider>();
    if (chatProvider.isLoading) return;

    setState(() => _isLoadingMore = true);

    await chatProvider.loadMessages();

    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  void _jumpToBottom() {
    if (widget.controller.hasClients) {
      widget.controller.jumpTo(widget.controller.position.maxScrollExtent);
    }
  }

  void _scheduleInitialScroll() {
    if (_hasInitiallyScrolled) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToBottom();
    });
  }

  void _scrollToBottomIfNeeded() {
    if (!widget.controller.hasClients) return;
    final double current = widget.controller.position.pixels;
    final double bottom = widget.controller.position.maxScrollExtent;

    // Only auto-scroll if user is near the bottom
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

  /// Generates a hash for change detection
  String _generateMessageHash(List<MessageEntity> messages) {
    if (messages.isEmpty) return '';
    final StringBuffer buffer = StringBuffer();
    for (final MessageEntity m in messages) {
      final String fileHash = m.fileUrl.isNotEmpty
          ? '${m.fileUrl.length}:${m.fileUrl.map((AttachmentEntity f) => f.url).join(",")}'
          : '';
      buffer.write(
        '${m.messageId}:${m.updatedAt.millisecondsSinceEpoch}:${m.status?.code ?? ""}:${m.fileStatus ?? ""}:$fileHash|',
      );
    }
    return buffer.toString();
  }

  /// Builds grouped messages with caching
  void _updateCachedDataIfNeeded(List<MessageEntity> messages) {
    final String currentHash = _generateMessageHash(messages);
    if (currentHash != _lastMessageHash) {
      _lastMessageHash = currentHash;
      _cachedGroupedMessages = _grouper.groupMessages(messages);
      _cachedTimeDiffs = MessageTimeDiffCalculator.calculateTimeDiffs(messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = context.watch<ChatProvider>();
    final SendMessageProvider sendMessageProvider = context
        .watch<SendMessageProvider>();
    final String? chatId = chatProvider.chat?.chatId;
    final bool isLoading = chatProvider.isLoading;

    if (chatId == null) {
      return SingleChildScrollView(
        child: EmptyPageWidget(
          icon: CupertinoIcons.chat_bubble_2,
          childBelow: const Text('no_messages_yet').tr(),
        ),
      );
    }

    final Box<GettedMessageEntity> box = Hive.box<GettedMessageEntity>(
      AppStrings.localChatMessagesBox,
    );

    return ValueListenableBuilder<Box<GettedMessageEntity>>(
      valueListenable: box.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<GettedMessageEntity> box, _) {
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
              return const Center(child: CupertinoActivityIndicator());
            }

            // Show empty state when not loading and no messages
            if (!isLoading && messages.isEmpty) {
              return SingleChildScrollView(
                child: EmptyPageWidget(
                  icon: CupertinoIcons.chat_bubble_2,
                  childBelow: const Text('no_messages_yet').tr(),
                ),
              );
            }

            // Prefetch sender names for performance
            chatProvider.prefetchSenderNames(messages);

            // Update cached data if messages changed
            _updateCachedDataIfNeeded(messages);

            // Schedule scroll behaviors
            _scheduleInitialScroll();
            _onMessagesChanged(messages.length);

            final GroupedMessages grouped =
                _cachedGroupedMessages ?? GroupedMessages.empty;
            final Map<String, Duration> timeDiffs =
                _cachedTimeDiffs ?? <String, Duration>{};

            return CustomScrollView(
              controller: widget.controller,
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                // Loading indicator at top for pagination
                if (_isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                  ),

                // Build slivers for each message group
                for (final MessageGroup group in grouped.groups) ...<Widget>[
                  // Date divider
                  SliverToBoxAdapter(
                    child: MessageTimeDivider(label: group.label),
                  ),
                  // Messages in this group using SliverList.builder for efficiency
                  SliverList.builder(
                    itemCount: group.messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final MessageEntity message = group.messages[index];
                      return _buildMessageTile(message, timeDiffs);
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  /// Builds a message tile with proper key for efficient updates
  Widget _buildMessageTile(
    MessageEntity message,
    Map<String, Duration> timeDiffs,
  ) {
    final String fileUrlHash = message.fileUrl.isNotEmpty
        ? message.fileUrl.map((AttachmentEntity f) => f.url).join(',')
        : '';
    final String keyValue =
        '${message.messageId}_${message.updatedAt.millisecondsSinceEpoch}_${message.fileStatus ?? ""}_${message.status?.code ?? ""}_$fileUrlHash';

    return MessageTile(
      key: ValueKey<String>(keyValue),
      message: message,
      timeDiff: timeDiffs[message.messageId] ?? const Duration(days: 5),
    );
  }
}
