import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../domain/entities/checkout/payment_item_entity.dart';
import '../../../providers/cart_provider.dart';
import 'review_widgets/review_item_card.dart';

class ReviewCartPage extends StatelessWidget {
  const ReviewCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    final List<PaymentItemEntity> paymentItemList =
        cartPro.orderBilling?.items ?? <PaymentItemEntity>[];
    if (paymentItemList.isEmpty) {
      return const Center(child: EmptyPageWidget(icon: Icons.local_shipping));
    }
    return ListView.separated(
      itemCount: paymentItemList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final PaymentItemEntity item = paymentItemList[index];
        return ReviewItemCard(detail: item);
      },
    );
  }
}
