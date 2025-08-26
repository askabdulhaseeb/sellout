import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/chat_interaction_panel/chat_interaction_panel.dart';
import '../widgets/pinned_message.dart/pinned_message.dart';
import '../widgets/message/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();

  bool _isAtBottom() {
    if (!scrollController.hasClients) return false;
    return scrollController.offset >=
        scrollController.position.maxScrollExtent - 50; // 50px tolerance
  }

  @override
  void initState() {
    super.initState();

    // Load messages after short delay
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });

    scrollController.addListener(() {
      final ChatProvider pro =
          Provider.of<ChatProvider>(context, listen: false);
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse && pro.expandedPinnedMessage) {
        pro.setPinnedMessageExpansion(false);
      } else if (direction == ScrollDirection.forward &&
          !pro.expandedPinnedMessage) {
        pro.setPinnedMessageExpansion(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final ChatEntity? chat = pro.chat;

        // After messages list updates, scroll to bottom if already at bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isAtBottom()) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(
                scrollController.position.maxScrollExtent,
              );
            }
          }
        });

        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (chat != null) {
              LocalUnreadMessagesService().clearCount(chat.chatId);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: chatAppBar(context),
            body: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: pro.expandedPinnedMessage ? 150 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: MessagesList(
                    chat: chat,
                    controller: scrollController,
                  ),
                ),
                if (chat?.pinnedMessage != null)
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: ChatPinnedMessage(chatId: chat!.chatId)),
              ],
            ),
            bottomNavigationBar: const ChatInteractionPanel(),
          ),
        );
      },
    );
  }
}
