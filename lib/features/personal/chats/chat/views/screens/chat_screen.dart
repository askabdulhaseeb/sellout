import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../widgets/core/app_bar/chat_app_bar.dart';
import '../widgets/core/messages_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatAppBar(context),
      body: FutureBuilder<bool>(
        future: Provider.of<ChatProvider>(context, listen: false).getMessages(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return const Column(
            children: <Widget>[
              MessagesList(),
            ],
          );
        },
      ),
    );
  }
}
