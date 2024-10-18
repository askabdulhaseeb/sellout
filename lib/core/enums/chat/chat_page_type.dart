import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilities/app_icons.dart';

enum ChatPageType {
  orders('orders', Icons.chat_outlined),
  services('services', AppIcons.story),
  groups('groups', CupertinoIcons.group);

  const ChatPageType(this.code, this.icon);
  final String code;
  final IconData icon;

  static ChatPageType fromJson(String json) => ChatPageType.values.firstWhere(
        (ChatPageType e) => e.code == json,
        orElse: () => ChatPageType.orders,
      );
}
