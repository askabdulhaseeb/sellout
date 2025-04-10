import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum BusienssBottomNavBarType {
  home('home', 0, Icons.home_outlined, Icons.home),
  add('add', 3, Icons.add_circle_outline, Icons.add_circle),
  chats('chats', 4, Icons.chat_outlined, Icons.chat),
  orders('order', 1, CupertinoIcons.shopping_cart, CupertinoIcons.shopping_cart),
  appointments('appointments', 2, Icons.edit_outlined, Icons.edit),
  checkout(
      'checkout', 5, Icons.monetization_on_outlined, Icons.monetization_on);

  const BusienssBottomNavBarType(
    this.code,
    this.number,
    this.icon,
    this.activeIcon,
  );
  final String code;
  final int number;
  final IconData icon;
  final IconData activeIcon;

  static List<BusienssBottomNavBarType> get list => <BusienssBottomNavBarType>[
        home,
        add,
        chats,
        orders,
        appointments,
        checkout
      ];
}
