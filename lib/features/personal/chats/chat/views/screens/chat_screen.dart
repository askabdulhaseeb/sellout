import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/chat_interaction_panel/chat_interaction_panel.dart';
import '../widgets/message/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Future<void>.delayed(
        const Duration(
          milliseconds: 300,
        ), () {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ChatEntity? chat =
        Provider.of<ChatProvider>(context, listen: false).chat;

    debugPrint(Provider.of<ChatProvider>(context, listen: false)
        .chat
        ?.persons
        .toString());
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          LocalUnreadMessagesService().clearCount(chat?.chatId ?? ''),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: chatAppBar(context),
        body: const SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: MessagesList()),
              ChatInteractionPanel()
            ],
          ),
        ),
      ),
    );
  }
}
