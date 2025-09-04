import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final ChatEntity? chat = pro.chat;

        return PopScope(
          onPopInvokedWithResult: (bool didPop, Object? result) {
            LocalUnreadMessagesService().clearCount(chat.chatId);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: chatAppBar(context),
            body: GestureDetector(
              onVerticalDragEnd: (DragEndDetails details) {
                // Swipe up
                if (details.primaryVelocity! < 0) {
                  if (pro.showPinnedMessage)
                    pro.setPinnedMessageVisibility(false);
                }
                // Swipe down
                else if (details.primaryVelocity! > 0) {
                  if (!pro.showPinnedMessage)
                    pro.setPinnedMessageVisibility(true);
                }
              },
              child: Column(
                children: <Widget>[
                  ChatPinnedMessage(chatId: chat!.chatId),
                  Expanded(
                    child: MessagesList(
                      chat: chat,
                      controller: scrollController,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const ChatInteractionPanel(),
          ),
        );
      },
    );
  }
}
