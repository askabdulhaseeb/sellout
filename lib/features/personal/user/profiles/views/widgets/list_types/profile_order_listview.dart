import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../order/view/screens/order_detail_screen.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../enums/order_type.dart';

class ProfileOrderListview extends StatelessWidget {
  const ProfileOrderListview({
    required this.filteredOrders,
    required this.postMap,
    required this.selectedStatus,
    super.key,
  });

  final List<OrderEntity> filteredOrders;
  final Map<String, PostEntity> postMap;
  final StatusType selectedStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredOrders.length,
      itemBuilder: (BuildContext context, int index) {
        final OrderEntity order = filteredOrders[index];
        final PostEntity? post = postMap[order.postId];

        return InkWell(
          onTap: () => showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: context,
            builder: (_) => OrderDetailsScreen(order: order),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 70,
                  width: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                      imageURL: post?.imageURL ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(post?.title ?? '',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelSmall),
                      Text('\$${order.price}',
                          style: Theme.of(context).textTheme.labelSmall),
                      if (selectedStatus.code == OrderType.completed.code)
                        Text('sale_completed'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                      if (selectedStatus.code == OrderType.cancelled.code)
                        Text('cancelled_order'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline)),
                      if (selectedStatus.code == OrderType.newOrder.code)
                        Text('congrats_order'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios, size: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
