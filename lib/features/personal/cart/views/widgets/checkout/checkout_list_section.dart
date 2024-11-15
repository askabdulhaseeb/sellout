import 'package:flutter/material.dart';

import '../../../domain/entities/checkout/check_out_entity.dart';
import 'tile/checkout_item_tile.dart';

class CheckoutListSection extends StatelessWidget {
  const CheckoutListSection({
    required this.checkOut,
    required this.currency,
    super.key,
  });
  final CheckOutEntity checkOut;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: checkOut.items.length,
      padding: const EdgeInsets.only(top: 4),
      itemBuilder: (BuildContext context, int index) {
        return CheckoutItemTile(item: checkOut.items[index], curency: currency);
      },
    );
  }
}
