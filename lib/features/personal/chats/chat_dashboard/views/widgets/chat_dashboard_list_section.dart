import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/coming_soon_overlay.dart';
import '../providers/chat_dashboard_provider.dart';
import 'chat_lists/group_chat_list_widget.dart';
import 'chat_lists/order_chat_list_widget.dart';

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
            return Expanded(
              child: ComingSoonOverlay(
                  title: 'coming_soon'.tr(),
                  subtitle: 'services_coming_soon_subtitle'.tr(),
                  icon: CupertinoIcons.hourglass),
            );
          // ServicesChatListWidget();
          case ChatPageType.groups:
            return const GroupChatListWidget();
          // default:
          //   return const Center(child: Text('No Chat List'));
        }
      },
    );
  }
}
