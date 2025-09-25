import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../providers/chat_provider.dart';
import '../message/tile/offer_message_tile.dart';
import '../message/tile/quote_message_tile.dart';
import '../message/tile/visiting_message_tile.dart';

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
                : chat.pinnedMessage!.quoteDetail != null
                    ? QuoteMessageTile(
                        message: chat.pinnedMessage!, showButtons: true)
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
    extends State<VisitingMessageTileAnimated> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        return AnimatedContainer(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: pro.showPinnedMessage
              ? Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    VisitingMessageTile(
                      message: widget.message,
                      showButtons: true,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
