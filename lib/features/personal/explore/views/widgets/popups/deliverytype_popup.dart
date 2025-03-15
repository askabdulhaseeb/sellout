import 'package:flutter/material.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../services/get_it.dart';
import '../../providers/explore_provider.dart';

class DeliveryTypeFilterDialog extends StatefulWidget {
  const DeliveryTypeFilterDialog({super.key});

  @override
  State<DeliveryTypeFilterDialog> createState() =>
      _DeliveryTypeFilterDialogState();
}

class _DeliveryTypeFilterDialogState extends State<DeliveryTypeFilterDialog> {
  ExploreProvider pro = ExploreProvider(locator(),locator());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: DeliveryType.values.map((DeliveryType deliveryType) {
          return ListTile(
            title: Text(deliveryType.code),
            onTap: () {
              pro.setDeliveryType(deliveryType);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
