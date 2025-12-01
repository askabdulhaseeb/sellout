import 'package:flutter/material.dart';
import '../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';

class OrderPostageItemCard extends StatelessWidget {
  const OrderPostageItemCard({
    required this.detail,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final PostageItemDetailEntity detail;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final DeliveryType deliveryType = detail.originalDeliveryType;
    final bool isFree = deliveryType == DeliveryType.freeDelivery;
    final bool isFast = detail.fastDelivery.requested == true;
    final bool isPaid = deliveryType == DeliveryType.paid;
    final List<RateEntity> rates = detail.shippingDetails
        .expand(
          (PostageDetailShippingDetailEntity d) =>
              d.ratesBuffered.where((RateEntity r) => r.objectId.isNotEmpty),
        )
        .toList();

    Widget content;
    if ((isPaid || isFast) && rates.isEmpty) {
      content = const Text('No rates available');
    } else if (isFree && !isFast) {
      content = const Text('Free Delivery');
    } else {
      content = rates.isNotEmpty
          ? Column(
              children: rates
                  .map(
                    (RateEntity rate) => ListTile(
                      title: Text(
                        '${rate.provider} · ${rate.serviceLevel.name}',
                      ),
                      trailing: FutureBuilder<String>(
                        future: rate.getPriceStr(),
                        builder: (_, AsyncSnapshot<String> snap) =>
                            Text(snap.data ?? '...'),
                      ),
                      leading: Radio<bool>(
                        value: true,
                        groupValue: selected,
                        onChanged: (_) => onSelect(),
                      ),
                      onTap: onSelect,
                    ),
                  )
                  .toList(),
            )
          : const SizedBox.shrink();
    }

    return Card(
      color: selected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Post: ${detail.postId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
