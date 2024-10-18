import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_dashboard_provider.dart';
import 'chat_lists/group_chat_list_widget.dart';
import 'chat_lists/order_chat_list_widget.dart';
import 'chat_lists/services_chat_list_widget.dart';

class ChatDashboardListSeaction extends StatelessWidget {
  const ChatDashboardListSeaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatDashboardProvider>(
      builder: (BuildContext context, ChatDashboardProvider chatPro, _) {
        switch (chatPro.currentPage) {
          case ChatPageType.orders:
            return const OrderChatListWidget();
          case ChatPageType.services:
            return const ServicesChatListWidget();
          case ChatPageType.groups:
            return const GroupChatListWidget();
          default:
            return const Center(child: Text('No Chat List'));
        }
      },
    );
  }
}
