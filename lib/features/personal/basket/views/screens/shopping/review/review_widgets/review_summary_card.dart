import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ReviewSummaryCard extends StatelessWidget {
  const ReviewSummaryCard({super.key, required this.summary});

  // summary is kept dynamic to avoid tight coupling in this small widget.
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    if (summary == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('postage_summary'.tr(),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: <Widget>[
                Text('${'total_posts'.tr()}: ${summary.totalPosts}'),
                Text('${'total_items'.tr()}: ${summary.totalItems}'),
                Text(
                    '${'total_quantity'.tr()}: ${summary.totalQuantityOfAllProducts}'),
                Text(
                    '${'fast_delivery_requested'.tr()}: ${summary.fastDeliveryRequested}'),
                Text(
                    '${'fast_delivery_items_count'.tr()}: ${summary.fastDeliveryItemsCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
