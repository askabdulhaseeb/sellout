import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/app_bar/chat_app_bar.dart';
import '../widgets/input_field/chat_input_field.dart';
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
    Provider.of<ChatProvider>(context, listen: false).getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {debugPrint(  Provider.of<ChatProvider>(context, listen: false).chat?.persons.toString());
    return Scaffold(
      appBar: chatAppBar(context),
      body: const Column(
        children: <Widget>[
          MessagesList(),
          ChatInputField(),
        ],
      ),
    );
  }
}
