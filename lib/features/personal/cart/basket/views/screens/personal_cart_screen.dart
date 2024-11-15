import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_save_later_toggle_section.dart';
import '../widgets/personal_cart_total_section.dart';
import 'pages/personal_cart_cart_item_list.dart';
import '../widgets/personal_cart_page_tile.dart';
import 'pages/personal_cart_save_later_item_list.dart';

class PersonalCartScreen extends StatelessWidget {
  const PersonalCartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('cart').tr()),
      body: Consumer<CartProvider>(
          builder: (BuildContext context, CartProvider cartPro, _) {
        return FutureBuilder<bool>(
          future: cartPro.getCart(),
          builder: (BuildContext context, AsyncSnapshot<bool> snap) {
            return Column(
              children: <Widget>[
                const PersonalCartPageTile(),
                const SizedBox(height: 24),
                const CartSaveLaterToggleSection(),
                cartPro.basketPage == CartItemType.cart
                    ? const PersonalCartItemList()
                    : const PersonalCartSaveLaterItemList(),
                if (cartPro.basketPage == CartItemType.cart)
                  const PersonalCartTotalSection(),
              ],
            );
          },
        );
      }),
    );
  }
}
