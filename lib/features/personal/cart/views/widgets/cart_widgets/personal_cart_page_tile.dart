import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class PersonalCartPageTile extends StatelessWidget {
  const PersonalCartPageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartPro, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _IconButton(
              title: 'shopping-basket'.tr(),
              isActive: cartPro.page == 1,
              onTap: () {}),
          Container(
            height: 3,
            width: 40,
            color: Theme.of(context).dividerColor,
          ),
          _IconButton(
              title: 'checkout'.tr(),
              isActive: cartPro.page == 2,
              onTap: () {}),
        ],
      );
    });
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle_outline_sharp, color: color),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
