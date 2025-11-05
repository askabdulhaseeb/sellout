import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/cart_widgets/cart_save_later_toggle_section.dart';
import '../../../widgets/cart_widgets/personal_cart_total_section.dart';
import 'pages/personal_cart_cart_item_list.dart';
import 'pages/personal_cart_save_later_item_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    // Return the content directly. The parent should provide scrolling or
    // bounded constraints if needed. Avoid using Expanded here because
    // this widget may be placed inside an unbounded parent.
    return Column(
      children: <Widget>[
        const CartSaveLaterToggleSection(),
        cartPro.basketPage == CartItemType.cart
            ? const PersonalCartItemList()
            : const PersonalCartSaveLaterItemList(),
        if (cartPro.basketPage == CartItemType.cart)
          const PersonalCartTotalSection(),
      ],
    );
  }
}
