import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/basket_type.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_widgets/personal_cart_page_tile.dart';
import 'basket_item_list_page.dart';

class PersonalBasketSection extends StatelessWidget {
  const PersonalBasketSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider pro, Widget? child) =>
          Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: <Widget>[
            const PersonalCartPageTile(),
            if (pro.basketType == BasketType.shoppingBasket)
              const BasketItemListPage()
          ],
        ),
      ),
    );
  }
}
