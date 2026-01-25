import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../user/profiles/views/user_profile/widgets/bottomsheets/unblock_user_bottomsheet.dart';
import '../../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../providers/chat_provider.dart';
import '../message/tile/offer_message_tile.dart';
import '../message/tile/quote_message_tile.dart';
import '../message/tile/visiting_message_tile.dart';

class ChatPinnedMessage extends StatelessWidget {
  const ChatPinnedMessage({required this.chatId, super.key});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        return ValueListenableBuilder<Box<ChatEntity>>(
          valueListenable: LocalChat.boxLive.listenable(
            keys: <dynamic>[chatId],
          ),
          builder: (BuildContext context, Box<ChatEntity> box, _) {
            final ChatEntity? chat = box.get(chatId);
            final bool isBlocked =
                pro.isOtherUserBlocked &&
                (pro.chat?.type == ChatType.private ||
                    pro.chat?.type == ChatType.product);

            // Show blocked message if user is blocked (priority over pinned messages)
            if (isBlocked) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'blocked_banner_message'.tr(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final String? otherUserId = pro.otherUserId;
                              final String displayName = otherUserId != null
                                  ? LocalUser()
                                            .userEntity(otherUserId)
                                            ?.displayName ??
                                        'this_user'.tr()
                                  : 'this_user'.tr();
                              final bool? confirmed =
                                  await showUnblockUserBottomSheet(
                                    context,
                                    name: displayName,
                                  );
                              if (confirmed != true) return;
                              await pro.toggleBlockPeer(block: false);
                            },
                            child: Text(
                              'unblock_user'.tr(),
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              );
            }

            // Show regular pinned messages if not blocked
            if (chat == null || chat.pinnedMessage == null) {
              return const SizedBox.shrink();
            }
            return chat.pinnedMessage!.offerDetail != null
                ? OfferMessageTileAnimated(message: chat.pinnedMessage!)
                : chat.pinnedMessage!.visitingDetail != null
                ? VisitingMessageTileAnimated(message: chat.pinnedMessage!)
                : chat.pinnedMessage!.quoteDetail != null
                ? QuoteMessageTile(
                    message: chat.pinnedMessage!,
                    pinnedMessage: true,
                  )
                : const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class OfferMessageTileAnimated extends StatefulWidget {
  const OfferMessageTileAnimated({required this.message, super.key});

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
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            OfferMessageTile(message: widget.message, showButtons: true),
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
  const VisitingMessageTileAnimated({required this.message, super.key});

  final MessageEntity message;

  @override
  State<VisitingMessageTileAnimated> createState() =>
      _VisitingMessageTileAnimatedState();
}

class _VisitingMessageTileAnimatedState
    extends State<VisitingMessageTileAnimated>
    with TickerProviderStateMixin {
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
