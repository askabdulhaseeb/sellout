import 'package:flutter/material.dart';

import '../../../utilities/app_icons.dart';

personalAppbar(BuildContext context) {
  return AppBar(
    centerTitle: false,
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Row(
      children: <Widget>[
        _IconButton(icon: AppIcons.setting, onPressed: () {}),
        _IconButton(icon: AppIcons.search, onPressed: () {}),
      ],
    ),
    actions: <Widget>[
      _IconButton(icon: AppIcons.notification, onPressed: () {}),
      _IconButton(icon: AppIcons.cart, onPressed: () {}),
      const SizedBox(width: 8),
    ],
  );
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onPressed});
  final IconData icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(child: Icon(icon)),
    );
  }
}
