import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../providers/chat_provider.dart';
import 'group_chat_title_widget.dart';
import 'private_chat_title_widget.dart';
import 'product_chat_title_widget.dart';

chatAppBar(BuildContext context) {
  final ChatEntity? chat = Provider.of<ChatProvider>(context).chat;
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          LocalUnreadMessagesService().clearCount(chat?.chatId ?? '');
        },
        icon: const Icon(Icons.arrow_back_ios_rounded)),
    leadingWidth: 40,
    title: chat?.type == ChatType.product
        ? const ProductChatTitleWidget()
        : chat?.type == ChatType.group
            ? const GroupChatTitleWidget()
            : const PrivateChatTitleWidget(),
  );
}
