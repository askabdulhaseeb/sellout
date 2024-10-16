import 'package:flutter/material.dart';

enum PersonalBottomNavBarType {
  home('home', 0, Icons.home_outlined, Icons.home),
  explore('explore', 1, Icons.explore_outlined, Icons.explore),
  services('services', 2, Icons.shopping_bag_outlined, Icons.shopping_bag),
  add('add', 3, Icons.add_circle_outline, Icons.add_circle),
  chats('chats', 4, Icons.chat_outlined, Icons.chat),
  profile('profile', 5, Icons.person_outline, Icons.person);

  const PersonalBottomNavBarType(
    this.code,
    this.number,
    this.icon,
    this.activeIcon,
  );
  final String code;
  final int number;
  final IconData icon;
  final IconData activeIcon;

  static List<PersonalBottomNavBarType> get list => <PersonalBottomNavBarType>[
        home,
        explore,
        services,
        add,
        chats,
        profile,
      ];
}
