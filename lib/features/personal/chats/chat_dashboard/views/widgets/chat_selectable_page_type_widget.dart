import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../providers/chat_dashboard_provider.dart';

class ChatSelectablePageTypeWidget extends StatelessWidget {
  const ChatSelectablePageTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ChatPageType> tabs = ChatPageType.values;
    return Consumer<ChatDashboardProvider>(
      builder: (BuildContext context, ChatDashboardProvider pagePro, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            children: tabs.map((ChatPageType tab) {
              final bool isSelected = pagePro.currentPage == tab;
              final Color? color = isSelected
                  ? Theme.of(context).primaryColor
                  : ColorScheme.of(context).outline;
              return Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: GestureDetector(
                    onTap: () => pagePro.setCurrentTabIndex(tab),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: ColorScheme.of(context).outlineVariant)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2),
                      child: Column(
                        children: <Widget>[
                          CustomSvgIcon(
                            size: 20,
                            assetPath: tab.icon,
                            color: color,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tab.code.tr(),
                            style: TextStyle(
                              fontSize: 14,
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
