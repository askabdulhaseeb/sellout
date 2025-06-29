import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../order/view/screens/order_detail_screen.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../../enums/order_type.dart';

class ProfileOrderTile extends StatelessWidget {
  const ProfileOrderTile({
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
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, OrderDetailsScreen.routeName,
                arguments: <String, dynamic>{
                  'order-id': order.orderId,
                });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
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
                      Text(
                        post?.title ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        '\$${order.price}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      if (selectedStatus == StatusType.completed)
                        Text(
                          'sale_completed'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      if (selectedStatus == StatusType.cancelled)
                        Text(
                          'cancelled_order'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline),
                        ),
                      if (selectedStatus.code == OrderType.newOrder.code)
                        Text(
                          'congrats_order'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Theme.of(context).primaryColor),
                        ),
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
