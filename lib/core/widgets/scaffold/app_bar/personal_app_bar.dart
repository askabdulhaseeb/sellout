import 'package:flutter/material.dart';

import '../../../../features/personal/cart/views/screens/personal_cart_screen.dart';
import '../../../../features/personal/setting/setting_dashboard/views/screens/personal_setting_screen.dart';
import '../../../utilities/app_icons.dart';

personalAppbar(BuildContext context) {
  return AppBar(
    centerTitle: false,
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shadowColor: Theme.of(context).dividerColor,
    title: Row(
      children: <Widget>[
        _IconButton(
          icon: AppIcons.setting,
          onPressed: () =>
              Navigator.of(context).pushNamed(PersonalSettingScreen.routeName),
        ),
        _IconButton(icon: AppIcons.search, onPressed: () {}),
      ],
    ),
    actions: <Widget>[
      _IconButton(icon: AppIcons.notification, onPressed: () {}),
      _IconButton(
        icon: AppIcons.cart,
        onPressed: () =>
            Navigator.of(context).pushNamed(PersonalCartScreen.routeName),
      ),
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
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(child: Icon(icon)),
      ),
    );
  }
}
