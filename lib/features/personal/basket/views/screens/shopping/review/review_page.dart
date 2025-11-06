import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../domain/entities/cart/cart_item_entity.dart';
import '../../../providers/cart_provider.dart';
import 'review_widgets/review_item_card.dart';

class ReviewOrderPage extends StatelessWidget {
  const ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();

    return FutureBuilder<bool>(
      future: cartPro.getCart(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<CartItemEntity> items = cartPro.cartItems.where((CartItemEntity e) => e.inCart).toList();

        return Column(
          children: <Widget>[
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: EmptyPageWidget(icon: Icons.local_shipping))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
