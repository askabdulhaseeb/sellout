import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';

class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({
    required this.post,
    required this.seller,
    required this.detail,
    super.key,
  });

  final dynamic post;
  final dynamic seller;
  final dynamic detail;

  @override
  Widget build(BuildContext context) {
    final String? image = post?.imageURL as String?;
    final String title = post?.title ?? detail.postId ?? '';
    final double price = (post?.price ?? 0) is num
        ? (post?.price ?? 0).toDouble()
        : double.tryParse((post?.price ?? '0').toString()) ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomNetworkImage(imageURL: image, size: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('${'seller'.tr()}: ${seller?.displayName ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Text('${'items'.tr()}: ${detail.itemCount}'),
                      const SizedBox(width: 12),
                      Text('${'quantity'.tr()}: ${detail.totalQuantity}'),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('\u0000${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (detail.fastDelivery.requested == true)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('fast_delivery'.tr(),
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
