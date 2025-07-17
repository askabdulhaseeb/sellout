import 'package:flutter/material.dart';
import '../../market_filter_address_dropdown.dart';
import 'delivery_filter_dropdown.dart';

class ItemFilterDeliveryAddedWidget extends StatelessWidget {
  const ItemFilterDeliveryAddedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 4,
      children: <Widget>[
        Expanded(
          child: DeliveryFilterDropdown(),
        ),
        Expanded(
          child: AddedFilterDropdown(),
        )
      ],
    );
  }
}
