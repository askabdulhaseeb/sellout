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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 6,
            children: tabs.map((ChatPageType tab) {
              final bool isSelected = pagePro.currentPage == tab;
              final Color borderColor = isSelected
                  ? Theme.of(context).primaryColor
                  : ColorScheme.of(context).outlineVariant;
              final Color color = isSelected
                  ? Theme.of(context).primaryColor
                  : ColorScheme.of(context).outline;
              return Expanded(
                child: GestureDetector(
                  onTap: () => pagePro.setCurrentTabIndex(tab),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 6,
                    ),
                    child: Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomSvgIcon(
                          size: 18,
                          assetPath: tab.icon,
                          color: color,
                        ),
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
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
