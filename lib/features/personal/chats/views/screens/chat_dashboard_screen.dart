import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';

class ChatDashboardScreen extends StatelessWidget {
  const ChatDashboardScreen({super.key});
  static const String routeName = '/chats';

  @override
  Widget build(BuildContext context) {
    return const PersonalScaffold(
      body: Center(child: Text('Chat Dashboard Screen')),
    );
  }
}
