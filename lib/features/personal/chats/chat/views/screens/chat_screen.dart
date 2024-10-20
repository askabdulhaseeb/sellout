import 'package:flutter/material.dart';

import '../widgets/core/app_bar/chat_app_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatAppBar(context),
      body: Container(),
    );
  }
}
