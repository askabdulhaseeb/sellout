import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';

class PersonalBottomNavBar extends StatelessWidget {
  const PersonalBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonalBottomNavProvider>(
        builder: (BuildContext context, PersonalBottomNavProvider navPro, _) {
      return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: navPro.currentTabIndex,
        onTap: (int index) => navPro.setCurrentTabIndex(index),
        items:
            PersonalBottomNavBarType.list.map((PersonalBottomNavBarType type) {
          return BottomNavigationBarItem(
            icon: Icon(
              type.icon,
              color: Theme.of(context).disabledColor,
            ),
            activeIcon: Icon(
              type.activeIcon,
              color: Theme.of(context).primaryColor,
            ),
            label: type.code.tr(),
          );
        }).toList(),
      );
    });
  }
}
