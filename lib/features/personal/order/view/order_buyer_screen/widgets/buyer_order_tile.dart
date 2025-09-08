import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/loaders/buyer_order_tile_loader.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../domain/entities/order_entity.dart';
import '../screen/order_buyer_screen.dart';

class BuyerOrderTileWidget extends StatelessWidget {
  const BuyerOrderTileWidget({
    required this.order,
    super.key,
    this.post,
  });

  final OrderEntity order;
  final PostEntity? post; // optionally pass cached post

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      // fallback: show loader until post is fetched
      return const BuyerOrderTileLoader();
    }

    return GestureDetector(
      onTap: () {
        AppNavigator.pushNamed(
          OrderBuyerScreen.routeName,
          arguments: <String, OrderEntity>{'order': order},
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
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    post!.priceStr,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order.orderStatus.code.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: order.orderStatus.color),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
