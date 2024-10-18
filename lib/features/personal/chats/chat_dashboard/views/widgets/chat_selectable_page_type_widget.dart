import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/shadow_container.dart';
import '../providers/chat_dashboard_provider.dart';

class ChatSelectablePageTypeWidget extends StatelessWidget {
  const ChatSelectablePageTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ChatPageType> tabs = ChatPageType.values;
    return Consumer<ChatDashboardProvider>(
      builder: (BuildContext context, ChatDashboardProvider pagePro, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: tabs.map((ChatPageType tab) {
              final bool isSelected = pagePro.currentPage == tab;
              final Color? color =
                  isSelected ? Theme.of(context).primaryColor : null;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: GestureDetector(
                    onTap: () => pagePro.setCurrentTabIndex(tab),
                    child: ShadowContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Icon(tab.icon, color: color),
                          const SizedBox(height: 4),
                          Text(
                            tab.code.tr(),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
