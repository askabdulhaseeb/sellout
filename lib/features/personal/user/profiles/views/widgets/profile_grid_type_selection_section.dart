import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../enums/profile_page_tab_type.dart';
import '../providers/profile_provider.dart';

class ProfileGridTypeSelectionSection extends StatelessWidget {
  const ProfileGridTypeSelectionSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isMe = (LocalAuth.uid ?? '') == (user?.uid ?? '-');
    final List<ProfilePageTabType> allTabs = ProfilePageTabType.list(isMe);

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

          final List<ProfilePageTabType> visibleTabs =
              allTabs.take(maxVisibleTabs).toList();
          final List<ProfilePageTabType> hiddenTabs =
              allTabs.skip(visibleTabs.length).toList();

          return Consumer<ProfileProvider>(
            builder: (BuildContext context, ProfileProvider userPro, _) {
              final int totalTabs =
                  visibleTabs.length + (hiddenTabs.isNotEmpty ? 1 : 0);
              final double tabWidth = availableWidth / totalTabs;

              return SizedBox(
                height: 36,
                child: Row(
                  children: <Widget>[
                    ...visibleTabs.map(
                      (ProfilePageTabType type) => SizedBox(
                        width: tabWidth,
                        child: _IconButton(
                          title: type.code.tr(),
                          isSelected: userPro.displayType == type,
                          onPressed: () => userPro.displayType = type,
                        ),
                      ),
                    ),
                    if (hiddenTabs.isNotEmpty)
                      SizedBox(
                        width: tabWidth,
                        child: PopupMenuButton<ProfilePageTabType>(
                          tooltip: 'More',
                          offset: const Offset(0, 36),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          onSelected: (ProfilePageTabType type) {
                            userPro.displayType = type;
                          },
                          itemBuilder: (BuildContext context) {
                            return hiddenTabs
                                .map(
                                  (ProfilePageTabType type) =>
                                      PopupMenuItem<ProfilePageTabType>(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'more'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: hiddenTabs
                                                .contains(userPro.displayType)
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).disabledColor,
                                        fontWeight: hiddenTabs
                                                .contains(userPro.displayType)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 18,
                                      color: hiddenTabs
                                              .contains(userPro.displayType)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 2,
                                  color:
                                      hiddenTabs.contains(userPro.displayType)
                                          ? AppTheme.primaryColor
                                          : Theme.of(context).dividerColor,
                                ),
                              ],
                            ),
                          ),
                        ),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : Theme.of(context).dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
