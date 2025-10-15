import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/chat/chat_model.dart';
import '../../providers/chat_dashboard_provider.dart';
import 'tiles/private_chat_dashboard_tile/private_chat_dashboard_tile.dart';

class ServicesChatListWidget extends StatelessWidget {
  const ServicesChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatDashboardProvider provider =
        context.watch<ChatDashboardProvider>();
    final List<ChatEntity> filteredChats = provider.filteredChats;

    if (filteredChats.isEmpty) {
      return Expanded(
        child: Center(
          child: EmptyPageWidget(
            icon: CupertinoIcons.chat_bubble_2,
            childBelow: Text(
              'no_chats_found'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (BuildContext context, int index) => Container(
          height: 1,
          color: Theme.of(context).dividerColor,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        itemCount: filteredChats.length,
        itemBuilder: (BuildContext context, int index) {
          final ChatEntity chat = filteredChats[index];
          return PrivateChatDashboardTile(chat: chat);
        },
      ),
    );
  }
}
