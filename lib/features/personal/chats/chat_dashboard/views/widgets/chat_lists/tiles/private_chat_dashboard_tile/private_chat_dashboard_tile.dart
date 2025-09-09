import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../chat/views/providers/chat_provider.dart';
import '../../../../../../chat/views/screens/chat_screen.dart';
import '../../../../../data/sources/local/local_unseen_messages.dart';
import '../../../../../domain/entities/chat/chat_entity.dart';
import 'types/private_chat_business_tile.dart';
import 'types/private_chat_user_tile.dart';

class PrivateChatDashboardTile extends StatelessWidget {
  const PrivateChatDashboardTile({required this.chat, super.key});
  final ChatEntity chat;

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context, listen: false);
    final bool isBusiness = chat.otherPerson().startsWith('BU');

    return GestureDetector(
      onTap: () async {
        pro.setChat(context, chat);
        await LocalUnreadMessagesService().clearCount(chat.chatId);
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: Column(
        children: <Widget>[
          isBusiness
              ? PrivateChatBusinessTile(chat: chat)
              : PrivateChatUserTile(chat: chat),
        ],
      ),
    );
  }
}
