import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../order/view/screens/order_detail_screen.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../order/domain/entities/order_entity.dart';

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
        return Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Column(
            spacing: 4,
            children: <Widget>[
              Row(
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
                        Row(
                          children: <Widget>[
                            Text(
                              order.orderStatus,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              DateFormat.yMMMd().format(order.createdAt),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                            ),
                          ],
                        ),
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
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      CustomElevatedButton(
                          padding: const EdgeInsets.all(6),
                          textStyle: TextTheme.of(context).bodySmall?.copyWith(
                              color: ColorScheme.of(context).onPrimary),
                          title: 'e_receipt'.tr(),
                          isLoading: false,
                          onTap: () {
                            AppNavigator.pushNamed(OrderDetailsScreen.routeName,
                                arguments: <String, String>{
                                  'order-id': order.orderId
                                });
                          }),
                    ],
                  ),
                ],
              ),
              const Divider()
            ],
          ),
        );
      },
    );
  }
}
