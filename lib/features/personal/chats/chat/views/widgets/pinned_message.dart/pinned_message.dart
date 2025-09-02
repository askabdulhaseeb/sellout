import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../providers/chat_provider.dart';
import '../message/tile/offer_message_tile.dart';
import '../message/tile/visiting_message_tile.dart';
import 'widgets/shape_borders/visiting_tile_handle_border.dart.dart';

class ChatPinnedMessage extends StatelessWidget {
  const ChatPinnedMessage({
    required this.chatId,
    super.key,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ChatEntity>>(
      valueListenable: LocalChat.boxLive.listenable(keys: <dynamic>[chatId]),
      builder: (BuildContext context, Box<ChatEntity> box, _) {
        final ChatEntity? chat = box.get(chatId);
        if (chat == null || chat.pinnedMessage == null) {
          return const SizedBox.shrink();
        }
        return chat.pinnedMessage!.offerDetail != null
            ? OfferMessageTileAnimated(
                message: chat.pinnedMessage!,
              )
            : chat.pinnedMessage!.visitingDetail != null
                ? VisitingMessageTileAnimated(
                    message: chat.pinnedMessage!,
                  )
                : const SizedBox.shrink();
      },
    );
  }
}

class OfferMessageTileAnimated extends StatefulWidget {
  const OfferMessageTileAnimated({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  @override
  State<OfferMessageTileAnimated> createState() =>
      _OfferMessageTileAnimatedState();
}

class _OfferMessageTileAnimatedState extends State<OfferMessageTileAnimated>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) => AnimatedContainer(
        height: pro.showPinnedMessage ? null : 0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        duration: const Duration(microseconds: 1000),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            OfferMessageTile(
              message: widget.message,
              showButtons: true,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

class VisitingMessageTileAnimated extends StatefulWidget {
  const VisitingMessageTileAnimated({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  @override
  State<VisitingMessageTileAnimated> createState() =>
      _VisitingMessageTileAnimatedState();
}

class _VisitingMessageTileAnimatedState
    extends State<VisitingMessageTileAnimated> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        return PopScope(
          onPopInvokedWithResult: (bool didPop, dynamic result) =>
              pro.resetPinnedMessageExpandedState(),
          child: AnimatedContainer(
            height: pro.showPinnedMessage ? null : 0,
            duration: const Duration(microseconds: 1000),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Material(
                  shape: const VisitileTileWithHandleBorder(),
                  elevation: pro.showPinnedMessage ? 4 : 0,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: VisitingMessageTile(
                      collapsable: true,
                      message: widget.message,
                      showButtons: true,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      debugPrint('visiting pinned tile expand/collapse');
                      pro.setPinnedMessageExpandedState();
                    },
                    child: const Icon(
                      Icons.keyboard_double_arrow_down_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
