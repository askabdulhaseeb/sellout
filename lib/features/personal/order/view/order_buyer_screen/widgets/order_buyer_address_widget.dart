import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/order_entity.dart';

class OrderBuyerAddressWIdget extends StatelessWidget {
  const OrderBuyerAddressWIdget({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'delivery_address'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(orderData.shippingAddress.address1),
        Text(orderData.shippingAddress.city),
        Text(orderData.shippingAddress.state.stateName),
        Text(orderData.shippingAddress.country.countryName),
      ],
    );
  }
}
