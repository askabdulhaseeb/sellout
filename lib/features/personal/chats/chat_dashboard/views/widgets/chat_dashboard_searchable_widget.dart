import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/searchable_textfield.dart';
import '../providers/chat_dashboard_provider.dart';

class ChatDashboardSearchableWidget extends StatelessWidget {
  const ChatDashboardSearchableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatDashboardProvider>(
        builder: (BuildContext context, ChatDashboardProvider pagePro, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: SearchableTextfield(
                onChanged: (String value) {
                  // TODO: search chat
                },
              ),
            ),
            const SizedBox(width: 8),
            pagePro.currentPage == ChatPageType.orders
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mark_chat_unread_outlined),
                  )
                : pagePro.currentPage == ChatPageType.services
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.card_membership_sharp),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.group_add_outlined),
                      ),
          ],
        ),
      );
    });
  }
}
