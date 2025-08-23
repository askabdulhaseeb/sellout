import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../message/tile/offer_message_tile.dart';
import '../message/tile/visiting_message_tile.dart';

/// Pinned message container — no internal animation logic
class ChatPinnedMessage extends StatelessWidget {
  const ChatPinnedMessage({
    required this.chatId,
    required this.showPinned,
    super.key,
  });

  final String chatId;
  final bool showPinned;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ChatEntity>>(
      valueListenable: LocalChat.boxLive.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<ChatEntity> box, _) {
        final ChatEntity? chat = box.get(chatId);
        if (chat == null || chat.pinnedMessage == null) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (chat.pinnedMessage!.offerDetail != null)
              OfferMessageTileAnimated(
                message: chat.pinnedMessage!,
                showPinned: showPinned,
              ),
            if (chat.pinnedMessage!.visitingDetail != null)
              VisitingMessageTileAnimated(
                showPinned: showPinned,
                message: chat.pinnedMessage!,
                isExpanded: showPinned,
              ),
          ],
        );
      },
    );
  }
}

class OfferMessageTileAnimated extends StatefulWidget {
  const OfferMessageTileAnimated({
    required this.message,
    required this.showPinned,
    super.key,
  });

  final MessageEntity message;
  final bool showPinned;

  @override
  State<OfferMessageTileAnimated> createState() =>
      _OfferMessageTileAnimatedState();
}

class _OfferMessageTileAnimatedState extends State<OfferMessageTileAnimated>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
      child: widget.showPinned
          ? OfferMessageTile(
              message: widget.message,
              showButtons: true,
            )
          : const SizedBox.shrink(),
    );
  }
}

class VisitingMessageTileAnimated extends StatefulWidget {
  const VisitingMessageTileAnimated({
    required this.message,
    required this.isExpanded,
    required this.showPinned,
    super.key,
  });

  final MessageEntity message;
  final bool isExpanded;
  final bool showPinned;

  @override
  State<VisitingMessageTileAnimated> createState() =>
      _VisitingMessageTileAnimatedState();
}

class _VisitingMessageTileAnimatedState
    extends State<VisitingMessageTileAnimated> with TickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant VisitingMessageTileAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.showPinned) {
      setState(() => _expanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      child: widget.showPinned
          ? VisitingMessageTile(
              isExpanded: _expanded,
              message: widget.message,
              showButtons: true,
            )
          : const SizedBox.shrink(),
    );
  }
}
