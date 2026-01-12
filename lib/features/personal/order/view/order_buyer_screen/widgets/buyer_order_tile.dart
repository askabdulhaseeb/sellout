import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/buyer_order_tile_loader.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../data/source/local/local_orders.dart';
import '../../../domain/entities/order_entity.dart';
import '../screen/order_buyer_screen.dart';

class BuyerOrderTileWidget extends StatelessWidget {
  const BuyerOrderTileWidget({required this.order, super.key, this.post});

  final OrderEntity order;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return const BuyerOrderTileLoader();
    }

    return StreamBuilder<dynamic>(
      stream: LocalOrders().watch(key: order.orderId),
      builder: (BuildContext context, _) {
        final OrderEntity orderData = LocalOrders().get(order.orderId) ?? order;

        return GestureDetector(
          onTap: () {
            AppNavigator.pushNamed(
              OrderBuyerScreen.routeName,
              arguments: <String, dynamic>{'order': orderData},
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: ColorScheme.of(context).outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomNetworkImage(
                    imageURL: post!.imageURL,
                    placeholder: post!.title,
                    size: 60,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post!.title,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${CountryHelper.currencySymbolHelper(post!.currency ?? '')}${orderData.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        orderData.orderStatus.code.tr(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: orderData.orderStatus.color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
