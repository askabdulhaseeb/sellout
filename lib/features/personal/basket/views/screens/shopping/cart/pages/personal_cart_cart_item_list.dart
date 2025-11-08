import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../data/models/cart/cart_item_model.dart';
import '../../../../../data/sources/local/local_cart.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../widgets/cart_widgets/tile/personal_cart_tile.dart';

class PersonalCartItemList extends StatelessWidget {
  const PersonalCartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = LocalAuth.uid ?? '';

    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider cartProvider, _) {
        return ValueListenableBuilder<Box<CartEntity>>(
          valueListenable: LocalCart().listenable(),
          builder: (BuildContext context, Box<CartEntity> box, _) {
            final CartEntity cart = box.values.firstWhere(
              (CartEntity element) => element.cartID == uid,
              orElse: () => CartModel(),
            );
            final List<CartItemEntity> items = cart.cartItems;

            if (items.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            // Use ListView.builder with proper keys and error handling
            return RefreshIndicator(
              onRefresh: () async {
                // Refresh cart data
                await cartProvider.getCart();
              },
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(color: Theme.of(context).dividerColor),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                primary: false,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final CartItemEntity item = items[index];
                  // Use unique key based on cartItemID to ensure proper widget identity
                  return PersonalCartTile(
                    key: ValueKey('cart_item_${item.cartItemID}'),
                    item: item,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
