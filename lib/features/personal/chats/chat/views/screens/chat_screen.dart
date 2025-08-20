import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/chat_interaction_panel/chat_interaction_panel.dart';
import '../widgets/message/messages_list.dart';
import '../widgets/message/tile/offer_message_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ChatEntity? chat =
        Provider.of<ChatProvider>(context, listen: false).chat;

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        LocalUnreadMessagesService().clearCount(chat?.chatId ?? '');
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Use Slivers inside a CustomScrollView
              Expanded(
                child: CustomScrollView(
                  scrollBehavior: const ScrollBehavior(),
                  slivers: <Widget>[
                    // SliverAppBar with dynamic bottom
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      title: chatAppBar(context),
                    ),
                    if (chat?.pinnedMessage != null)
                      SliverAppBar(
                        toolbarHeight: 150,
                        pinned: true,
                        automaticallyImplyLeading: false,
                        floating: true,
                        flexibleSpace: chat?.pinnedMessage == null
                            ? null
                            : ChatPinnedOfferMessage(chat: chat!),
                      ),
                    // Messages list as a sliver
                    const MessagesList(),
                  ],
                ),
              ),
              // Keep interaction panel fixed at bottom
              const ChatInteractionPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatPinnedOfferMessage extends StatelessWidget {
  const ChatPinnedOfferMessage({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[OfferMessageTile(message: chat.pinnedMessage!)],
    );
  }
}
