import 'package:flutter/material.dart';
import '../../../widgets/cart_widgets/personal_cart_total_section.dart';
import 'pages/personal_cart_cart_item_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        children: <Widget>[
          Expanded(child: PersonalCartItemList()),
          PersonalCartTotalSection(),
        ],
      ),
    );
  }
}
