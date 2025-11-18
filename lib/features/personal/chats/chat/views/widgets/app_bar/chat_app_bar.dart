import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_icon_button.dart';
import '../../../../chat_dashboard/data/sources/local/local_unseen_messages.dart';
import '../../../../chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../providers/chat_provider.dart';
import 'group_chat_title_widget.dart';
import 'private_chat_title_widget.dart';
import 'product_chat_title_widget.dart';

chatAppBar(BuildContext context) {
  final ChatEntity? chat = Provider.of<ChatProvider>(context).chat;
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    title: Row(
      children: <Widget>[
        CustomIconButton(
          bgColor: Colors.transparent,
          padding: const EdgeInsets.all(6),
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 16,
          onPressed: () {
            Navigator.pop(context);
            LocalUnreadMessagesService().clearCount(chat?.chatId ?? '');
          },
        ),
        Expanded(
          child: chat?.productInfo?.type == ChatType.product
              ? const ProductChatTitleWidget()
              : chat?.productInfo?.type == ChatType.service
                  ? const PrivateChatTitleWidget()
                  : chat?.type == ChatType.group
                      ? const GroupChatTitleWidget()
                      : const PrivateChatTitleWidget(),
        ),
      ],
    ),
  );
}
