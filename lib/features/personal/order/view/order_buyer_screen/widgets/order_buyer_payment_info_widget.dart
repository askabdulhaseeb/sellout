import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../domain/entities/order_entity.dart';

class OrderBuyerPaymentInfoWidget extends StatelessWidget {
  const OrderBuyerPaymentInfoWidget({
    required this.orderData,
    required this.post,
    super.key,
  });

  final OrderEntity orderData;
  final PostEntity? post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'payment_info'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InDevMode(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(AppStrings.visa, fit: BoxFit.contain),
              ),
              Text(
                '${CountryHelper.currencySymbolHelper(post?.currency ?? '')}${orderData.totalAmount.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('1 ${'item'.tr()}'),
            Text(
              '${CountryHelper.currencySymbolHelper(post?.currency ?? '')}${orderData.price.toStringAsFixed(2)}',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'postage'.tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              orderData.shippingDetails != null &&
                      orderData.shippingDetails!.postage.isNotEmpty
                  ? '${CountryHelper.currencySymbolHelper(post?.currency ?? orderData.paymentDetail.postCurrency)}${(orderData.shippingDetails!.postage.first.coreAmount ?? 0).toString()}'
                  : '${CountryHelper.currencySymbolHelper(post?.currency ?? orderData.paymentDetail.postCurrency)}0.00',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'order_total'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${CountryHelper.currencySymbolHelper(post?.currency ?? '')}${orderData.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
