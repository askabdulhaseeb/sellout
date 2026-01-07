import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/order_entity.dart';
import 'two_style_text.dart';

class OrderBuyerTrackingDetailsSection extends StatelessWidget {
  const OrderBuyerTrackingDetailsSection({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'tracking_details'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TwoStyleText(
          firstText: 'postal_service'.tr(),
          secondText:
              orderData.shippingDetails != null &&
                  orderData.shippingDetails!.postage.isNotEmpty
              ? (orderData.shippingDetails!.postage.first.serviceName ??
                    orderData.shippingDetails!.postage.first.provider ??
                    '-')
              : '-',
        ),
        TwoStyleText(
          firstText: 'courier'.tr(),
          secondText:
              orderData.shippingDetails != null &&
                  orderData.shippingDetails!.postage.isNotEmpty
              ? (orderData.shippingDetails!.postage.first.provider ?? '-')
              : '-',
        ),
        TwoStyleText(
          firstText: 'tracking_number'.tr(),
          secondText: orderData.trackId?.isNotEmpty == true
              ? orderData.trackId!
              : (orderData.shippingDetails != null &&
                        orderData.shippingDetails!.postage.isNotEmpty
                    ? (orderData.shippingDetails!.postage.first.shipmentId ??
                          '-')
                    : '-'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
