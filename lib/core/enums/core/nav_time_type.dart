import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_icons.dart';

enum NavItemType {
  home('Home', 0, Icons.home_outlined, Icons.home),
  explore('Explore', 1, Icons.explore_outlined, Icons.explore),
  add('Add', 2, AppIcons.add, AppIcons.add),
  chat(
    'Chat',
    3,
    CupertinoIcons.chat_bubble_2,
    CupertinoIcons.chat_bubble_2_fill,
  ),
  profile('Profile', 4, CupertinoIcons.person, CupertinoIcons.person_fill);

  const NavItemType(this.display, this.kIndex, this.icon, this.activeIcon);
  final String display;
  final int kIndex;
  final IconData icon;
  final IconData activeIcon;

  static const List<NavItemType> list = NavItemType.values;

  static NavItemType fromIndex(int index) {
    return list.firstWhere((NavItemType e) => e.kIndex == index);
  }
}
