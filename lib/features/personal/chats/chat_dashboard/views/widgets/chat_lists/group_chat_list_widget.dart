import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/text_display/empty_page_widget.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import '../../providers/chat_dashboard_provider.dart';
import 'tiles/group_chat_dashbord_tile.dart';

class GroupChatListWidget extends StatelessWidget {
  const GroupChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatDashboardProvider provider = context
        .watch<ChatDashboardProvider>();
    final List<ChatEntity> chats = provider.filteredChats
        .where((ChatEntity c) => c.type == ChatType.group)
        .toList();
    if (chats.isEmpty) {
      return Expanded(
        child: Center(
          child: EmptyPageWidget(
            icon: CupertinoIcons.chat_bubble_2,
            childBelow: Text('no_chats_found'.tr()),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (_, __) => Container(
          height: 1,
          color: Theme.of(context).dividerColor,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        itemCount: chats.length,
        itemBuilder: (_, int index) {
          final ChatEntity chat = chats[index];
          return GroupChatDashbordTile(chat: chat);
        },
      ),
    );
  }
}
