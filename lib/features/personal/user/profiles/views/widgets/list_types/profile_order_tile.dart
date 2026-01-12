import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_spacings.dart';
import '../../../../../../../core/enums/core/status_type.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../order/view/screens/order_seller_screen.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../order/domain/entities/order_entity.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';

class SellerOrderTile extends StatelessWidget {
  const SellerOrderTile({required this.order, super.key});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'Building SellerOrderTile for orderId: ${order.orderId}${order.orderStatus.json}',
    );
    final StatusType selectedStatus = order.orderStatus;
    return FutureBuilder<PostEntity?>(
      future: LocalPost().getPost(order.postId),
      builder: (BuildContext context, AsyncSnapshot<PostEntity?> snapshot) {
        final PostEntity? post = snapshot.data;
        return InkWell(
          onTap: () {
            AppNavigator.pushNamed(
              OrderSellerScreen.routeName,
              arguments: <String, dynamic>{'order-id': order.orderId},
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6),
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
                              '${CountryHelper.currencySymbolHelper(order.paymentDetail.postCurrency)}${order.totalAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            if (selectedStatus == StatusType.delivered)
                              Text(
                                'sale_completed'.tr(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                              ),
                            if (selectedStatus == StatusType.cancelled)
                              Text(
                                'cancelled_order'.tr(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                              ),
                            if (selectedStatus == StatusType.shipped)
                              Text(
                                'shipped_order'.tr(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                              ),
                            if (selectedStatus == StatusType.pending)
                              Text(
                                'congrats_order'.tr(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: order.orderStatus.bgColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    order.orderStatus.code.tr(),
                    style: TextTheme.of(
                      context,
                    ).bodyMedium?.copyWith(color: order.orderStatus.color),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
