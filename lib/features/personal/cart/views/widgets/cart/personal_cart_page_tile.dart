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
            title: 'shopping_basket'.tr(),
            isActive: cartPro.page == 1,
            onTap: () => cartPro.page = 1,
          ),
          Container(
            height: 3,
            width: 40,
            color: Theme.of(context).dividerColor,
          ),
          _IconButton(
            title: 'checkout'.tr(),
            isActive: cartPro.page == 2,
            onTap: () => cartPro.page = 2,
          ),
          Container(
            height: 3,
            width: 40,
            color: Theme.of(context).dividerColor,
          ),
          _IconButton(
            title: 'payment_options'.tr(),
            isActive: cartPro.page == 3,
            onTap: () => cartPro.page = 3,
          ),
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
        width: MediaQuery.sizeOf(context).width / 6,
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
