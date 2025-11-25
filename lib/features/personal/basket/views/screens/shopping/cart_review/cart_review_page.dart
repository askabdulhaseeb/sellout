import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../domain/entities/cart/add_shipping_response_entity.dart';
import '../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../providers/cart_provider.dart';
import 'review_widgets/review_item_card.dart';

class ReviewCartPage extends StatelessWidget {
  const ReviewCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    final AddShippingResponseEntity? shippingResponse =
        cartPro.addShippingResponse;
    if (shippingResponse != null) {
      final List<AddShippingCartItemEntity> shippingItems = shippingResponse
          .cart.cartItems
          .where((AddShippingCartItemEntity item) =>
              item.status == CartItemStatusType.cart)
          .toList();
      final Map<String, CartItemEntity> cartItemMap = <String, CartItemEntity>{
        for (final CartItemEntity item in cartPro.cartItems)
          item.cartItemID: item,
      };

      if (shippingItems.isEmpty) {
        return const Center(child: EmptyPageWidget(icon: Icons.local_shipping));
      }

      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemCount: shippingItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final AddShippingCartItemEntity shippingItem =
                    shippingItems[index];
                final CartItemEntity detail =
                    cartItemMap[shippingItem.cartItemId] ??
                        CartItemEntity(
                          quantity: shippingItem.quantity,
                          postID: shippingItem.postId,
                          listID: shippingItem.listId,
                          color: shippingItem.color,
                          size: shippingItem.size,
                          cartItemID: shippingItem.cartItemId,
                          status: shippingItem.status,
                        );
                return ReviewItemCard(
                  detail: detail,
                  shippingDetail: shippingItem,
                );
              },
            ),
          ),
        ],
      );
    }

    return FutureBuilder<bool>(
      future: cartPro.getCart(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        // Only show items with status 'cart'
        final List<CartItemEntity> items = cartPro.cartItems
            .where((CartItemEntity e) => e.status == CartItemStatusType.cart)
            .toList();

        return Column(
          children: <Widget>[
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: EmptyPageWidget(icon: Icons.local_shipping))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final CartItemEntity item = items[index];
                        return ReviewItemCard(detail: item);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
