import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../../core/widgets/text_display/shadow_container.dart';
import '../../../../../domain/entities/checkout/payment_item_entity.dart';
import '../../../../../domain/entities/checkout/payment_item_shipping_details_entity.dart';
import 'package:flutter/material.dart';

class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({required this.detail, super.key});
  final PaymentItemEntity? detail;

  @override
  Widget build(BuildContext context) {
    // Otherwise fetch post, then seller
    return _ReviewItemContent(detail: detail);
  }
}

class _ReviewItemContent extends StatelessWidget {
  const _ReviewItemContent({required this.detail});

  final PaymentItemEntity? detail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? image = detail?.imageUrls.first;
    final String title = detail?.name ?? 'na'.tr();
    final int quantity = detail?.quantity ?? 1;

    // PaymentItemEntity does not have size/color, so skip attributeChips
    final List<Widget> attributeChips = <Widget>[];

    // Get the first shipping detail if available
    final PaymentItemShippingDetailsEntity? shipping =
        (detail?.shippingDetails.isNotEmpty ?? false)
        ? detail!.shippingDetails.first
        : null;
    final String shippingProvider = shipping?.provider ?? '-';
    final String shippingService = shipping?.serviceName ?? '-';
    final double shippingPrice = shipping?.convertedBufferAmount ?? 0.0;

    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomNetworkImage(imageURL: image, size: 64),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (attributeChips.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 6, children: attributeChips),
                    ],
                    // Show shipping provider/service if available
                    if (shipping != null &&
                        shippingProvider != '' &&
                        shippingService != '') ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        '${'shipping_provider'.tr()}: $shippingProvider',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '${'shipping_service'.tr()}: $shippingService',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PriceBreakdown(
            total: detail?.totalPrice,
            unitPrice: double.tryParse(detail?.price ?? '') ?? 0.0,
            quantity: quantity,
            shippingPrice: shippingPrice,
            currency: CountryHelper.currencySymbolHelper(
              shipping?.convertedCurrency,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({
    required this.currency,
    required this.total,
    required this.unitPrice,
    required this.quantity,
    required this.shippingPrice,
  });
  final String currency;
  final String? total;
  final double unitPrice;
  final int quantity;
  final double? shippingPrice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double subtotal = unitPrice * quantity;
    final double totalWithShipping = subtotal + (shippingPrice ?? 0.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Subtotal with quantity
        Text(
          '${'subtotal'.tr()} ($quantity): $currency${subtotal.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        if ((shippingPrice ?? 0.0) > 0) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            '${'shipping'.tr()}: $currency${shippingPrice?.toStringAsFixed(2) ?? '0.00'}',
            style: theme.textTheme.bodyMedium,
          ),
        ],

        const SizedBox(height: 8),
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${'total'.tr()}: $currency${totalWithShipping.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
