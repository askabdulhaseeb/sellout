import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/cart_page_bottom_item_type.dart';
import '../providers/cart_provider.dart';

class PersonalAppBarBottomSection extends StatelessWidget {
  const PersonalAppBarBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Selector<CartProvider, CartPageBottomItemType>(
        selector: (BuildContext context, CartProvider cartPro) =>
            cartPro.bottomItemType,
        builder: (BuildContext context, CartPageBottomItemType type, _) {
          const List<CartPageBottomItemType> items =
              CartPageBottomItemType.values;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items.map(
              (CartPageBottomItemType item) {
                return _Item(isSelected: type == item, type: item);
              },
            ).toList(),
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.isSelected, required this.type});

  final bool isSelected;
  final CartPageBottomItemType type;

  @override
  Widget build(BuildContext context) {
    final TextStyle active = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
    const TextStyle inactive = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
    );
    return InkWell(
      onTap: () => Provider.of<CartProvider>(context, listen: false)
          .bottomItemType = type,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            type.code.tr(),
            style: isSelected ? active : inactive,
          ).tr(),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 100,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
          )
        ],
      ),
    );
  }
}
