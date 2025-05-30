import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../providers/chat_provider.dart';
import 'group_chat_title_widget.dart';
import 'private_chat_title_widget.dart';
import 'product_chat_title_widget.dart';

chatAppBar(BuildContext context) {
  final ChatEntity? chat = Provider.of<ChatProvider>(context).chat;
  return AppBar(
    title: chat?.type == ChatType.product
        ? const ProductChatTitleWidget()
        : chat?.type == ChatType.group
            ? const GroupChatTitleWidget()
            : const PrivateChatTitleWidget(),
  );
}
