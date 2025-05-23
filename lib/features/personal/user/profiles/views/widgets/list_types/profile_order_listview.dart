import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../post/domain/entities/post_entity.dart';
import '../../../../../post/domain/params/get_specific_post_param.dart';
import '../../../domain/entities/orderentity.dart';
import '../../enums/order_type.dart';
import '../../providers/profile_provider.dart';

class ProfileOrderListview extends StatelessWidget {
  const ProfileOrderListview({
    required this.filteredOrders,
    required this.pro,
    required this.selectedStatus,
    super.key,
  });

  final List<OrderEntity> filteredOrders;
  final ProfileProvider pro;
  final OrderType selectedStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredOrders.length,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: pro.getPostByPostId(
              GetSpecificPostParam(postId: filteredOrders[index].postId)),
          builder: (BuildContext context,
              AsyncSnapshot<DataState<PostEntity>> postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (postSnapshot.hasError || !postSnapshot.hasData) {
              return Center(child: Text('something_wrong'.tr()));
            }

            final DataState<PostEntity>? post = postSnapshot.data;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
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
                        imageURL: post?.entity?.imageURL ?? '',
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
                        Text(post?.entity?.title ?? '',
                            maxLines: 1,
                            style: Theme.of(context).textTheme.labelSmall),
                        Text(
                            '\$${filteredOrders[index].price}', // Assuming price exists
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline)),
                        if (selectedStatus.code == OrderType.newOrder.code)
                          Text('congrats_order'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios, size: 12),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
