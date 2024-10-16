import 'package:flutter/material.dart';

class ChatDashboardScreen extends StatelessWidget {
  const ChatDashboardScreen({super.key});
  static const String routeName = '/chats';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Dashboard')),
      body: const Center(child: Text('Chat Dashboard Screen')),
    );
  }
}
