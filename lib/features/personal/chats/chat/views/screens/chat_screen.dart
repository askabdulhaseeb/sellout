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
  bool showPinned = true;

  @override
  void initState() {
    super.initState();

    // Load messages after short delay
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });

    // Listen to scroll direction to hide/show pinned message dynamically
    scrollController.addListener(() {
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse && showPinned) {
        setState(() => showPinned = false);
      } else if (direction == ScrollDirection.forward && !showPinned) {
        setState(() => showPinned = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ChatEntity? chat =
        Provider.of<ChatProvider>(context, listen: false).chat;

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (chat != null) {
          LocalUnreadMessagesService().clearCount(chat.chatId);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: chatAppBar(context),
        body: Column(
          children: <Widget>[
            if (chat?.pinnedMessage != null)
              ChatPinnedMessage(
                chatId: chat!.chatId,
                showPinned: showPinned,
              ),
            Expanded(
              child: MessagesList(
                chat: chat,
                controller: scrollController,
              ),
            ),
            // Smooth floating pinned message
          ],
        ),
        bottomNavigationBar: const ChatInteractionPanel(),
      ),
    );
  }
}
