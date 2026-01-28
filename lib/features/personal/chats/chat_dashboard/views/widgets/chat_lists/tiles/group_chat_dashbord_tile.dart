import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../../../core/widgets/media/profile_photo.dart';
import '../../../../../chat/views/providers/chat_provider.dart';
import '../../../../../chat/views/screens/chat_screen.dart';
import '../../../../data/sources/local/local_unseen_messages.dart';
import '../../../../domain/entities/chat/chat_entity.dart';
import '../../unseen_message_badge.dart';

class GroupChatDashbordTile extends StatelessWidget {
  const GroupChatDashbordTile({required this.chat, super.key});
  final ChatEntity chat;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Provider.of<ChatProvider>(
          context,
          listen: false,
        ).setChat(context, chat);
        await LocalUnreadMessagesService().clearCount(chat.chatId);
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: Row(
        children: <Widget>[
          ProfilePhoto(
            url: chat.groupInfo?.groupThumbnailURL,
            placeholder: chat.groupInfo?.title ?? '',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chat.groupInfo?.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  chat.lastMessage?.displayText ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                chat.lastMessage?.createdAt.timeAgo ?? '',
                style: const TextStyle(fontSize: 10),
              ),
              UnreadMessageBadgeWidget(chatId: chat.chatId),
            ],
          ),
        ],
      ),
    );
  }
}
