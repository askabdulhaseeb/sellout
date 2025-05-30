import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/models/cart/cart_item_model.dart';
import '../../../data/sources/local_cart.dart';
import '../../widgets/cart_widgets/tile/personal_cart_tile.dart';

class PersonalCartItemList extends StatelessWidget {
  const PersonalCartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = LocalAuth.uid ?? '';
    return ValueListenableBuilder<Box<CartEntity>>(
      valueListenable: LocalCart().listenable(),
      builder: (BuildContext context, Box<CartEntity> box, _) {
        final CartEntity cart = box.values.firstWhere(
          (CartEntity element) => element.cartID == uid,
          orElse: () => CartModel(),
        );
        final List<CartItemEntity> items = cart.cartItems;

        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final CartItemEntity item = items[index];
              return PersonalCartTile(item: item);
            },
          ),
        );
      },
    );
  }
}
