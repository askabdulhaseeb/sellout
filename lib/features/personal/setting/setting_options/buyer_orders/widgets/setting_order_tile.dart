import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../order/view/screens/order_detail_screen.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../user/profiles/views/enums/order_type.dart';

class BuyerOrderTIle extends StatelessWidget {
  const BuyerOrderTIle({
    required this.order,
    required this.selectedStatus,
    super.key,
  });

  final OrderEntity order;
  final StatusType selectedStatus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(order.postId),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomNetworkImage(
                  imageURL: post?.imageURL ?? '',
                  size: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post?.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${order.price}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat.yMMMd().format(order.createdAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    const SizedBox(height: 4),
                    if (selectedStatus == StatusType.completed)
                      Text(
                        'sale_completed'.tr(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    if (selectedStatus == StatusType.cancelled)
                      Text(
                        'cancelled_order'.tr(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    if (selectedStatus.code == OrderType.newOrder.code)
                      Text(
                        'congrats_order'.tr(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      AppNavigator.pushNamed(OrderDetailsScreen.routeName,
                          arguments: {'order-id': order.orderId});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    child: const Text('View'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Add more detailed action if needed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    child: const Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
