import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums/user_profile_page_tab_type.dart';
import '../providers/user_profile_provider.dart';

class UserProfileGridTypeSelectionSection extends StatelessWidget {
  const UserProfileGridTypeSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UserProfilePageTabType> allTabs = UserProfilePageTabType.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          const double moreButtonWidth = 80;
          const double minTabWidth = 80;

          int maxVisibleTabs = allTabs.length;
          double totalTabWidth = allTabs.length * minTabWidth;

          if (totalTabWidth > availableWidth) {
            maxVisibleTabs = ((availableWidth - moreButtonWidth) ~/ minTabWidth)
                .clamp(0, allTabs.length);
          }

          final List<UserProfilePageTabType> visibleTabs =
              allTabs.take(maxVisibleTabs).toList();
          final List<UserProfilePageTabType> hiddenTabs =
              allTabs.skip(visibleTabs.length).toList();

          return Consumer<UserProfileProvider>(
            builder: (BuildContext context, UserProfileProvider provider, _) {
              final int totalTabs =
                  visibleTabs.length + (hiddenTabs.isNotEmpty ? 1 : 0);
              final double tabWidth = availableWidth / totalTabs;

              return SizedBox(
                height: 36,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ...visibleTabs.map(
                          (UserProfilePageTabType type) => SizedBox(
                            width: tabWidth,
                            child: _IconButton(
                              title: type.code.tr(),
                              isSelected: provider.displayType == type,
                              onPressed: () => provider.displayType = type,
                            ),
                          ),
                        ),
                        if (hiddenTabs.isNotEmpty)
                          SizedBox(
                            width: tabWidth,
                            child: PopupMenuButton<UserProfilePageTabType>(
                              tooltip: 'More',
                              offset: const Offset(0, 36),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onSelected: (UserProfilePageTabType type) {
                                provider.displayType = type;
                              },
                              itemBuilder: (BuildContext context) {
                                return hiddenTabs
                                    .map(
                                      (UserProfilePageTabType type) =>
                                          PopupMenuItem<UserProfilePageTabType>(
                                        value: type,
                                        child: Text(type.code.tr()),
                                      ),
                                    )
                                    .toList();
                              },
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: null,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'more'.tr(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: hiddenTabs.contains(
                                                      provider.displayType)
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : ColorScheme.of(context)
                                                      .onSurface
                                                      .withValues(alpha: 0.4),
                                              fontWeight: hiddenTabs.contains(
                                                      provider.displayType)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              size: 18,
                                              color: hiddenTabs.contains(
                                                      provider.displayType)
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : ColorScheme.of(context)
                                                      .onSurface
                                                      .withValues(alpha: 0.4)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: hiddenTabs
                                              .contains(provider.displayType)
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
                                    ),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: ColorScheme.of(context)
                                              .onSurface
                                              .withValues(alpha: 0.2)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.title,
    required this.isSelected,
    this.onPressed,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : ColorScheme.of(context).onSurface.withValues(alpha: 0.2),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(
                color:
                    ColorScheme.of(context).onSurface.withValues(alpha: 0.2)),
          )
        ],
      ),
    );
  }
}
