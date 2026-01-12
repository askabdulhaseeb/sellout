import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/feed/views/widgets/post/widgets/section/buttons/type/widgets/post_buy_now_button.dart';
import '../../../domain/entities/order_entity.dart';

class BuyerOrderProductDetailWidget extends StatelessWidget {
  const BuyerOrderProductDetailWidget({
    required this.post,
    required this.orderData,
    super.key,
  });

  final PostEntity? post;
  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            spacing: AppSpacing.hSm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: post?.imageURL != null
                    ? CustomNetworkImage(
                        imageURL: post!.imageURL,
                        size: 60,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image, size: 80),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post?.title ?? 'na'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '${CountryHelper.currencySymbolHelper(orderData.paymentDetail.buyerCurrency)}${orderData.paymentDetail.convertedPrice}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          PostBuyNowButton(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            detailWidgetColor: null,
            detailWidgetSize: null,
            detailWidget: false,
            post: post!,
            buyNowText: 'buy_again'.tr(),
            buyNowColor: Colors.transparent,
            buyNowTextStyle: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
