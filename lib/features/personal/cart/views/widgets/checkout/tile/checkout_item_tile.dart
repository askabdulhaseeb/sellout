import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../domain/entities/checkout/check_out_item_entity.dart';

class CheckoutItemTile extends StatelessWidget {
  const CheckoutItemTile({
    required this.item,
    required this.curency,
    super.key,
  });
  final CheckOutItemEntity item;
  final String curency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
              imageURL: item.image.first.url,
              size: 100,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(item.condition.code.tr()),
                const SizedBox(height: 2),
                Text('${'quantity'.tr()}: ${item.quantity}'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                item.price.toStringAsFixed(2),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(curency.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }
}
