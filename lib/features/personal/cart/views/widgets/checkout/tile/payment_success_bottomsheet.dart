import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/bottom_sheets/widgets/address_tile.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../domain/entities/checkout/order_billing_entity.dart';
import '../../../providers/cart_provider.dart';

class PaymentSuccessSheet extends StatefulWidget {
  const PaymentSuccessSheet({super.key});

  @override
  State<PaymentSuccessSheet> createState() => _PaymentSuccessSheetState();
}

class _PaymentSuccessSheetState extends State<PaymentSuccessSheet> {
  bool showOrderInfo = false;

  @override
  Widget build(BuildContext context) {
    final CartProvider pro = Provider.of<CartProvider>(context, listen: false);
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: double.infinity),
              Text(
                'payment_successful'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                textAlign: TextAlign.center,
                'payment_successful_description'.tr(),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.check_circle_outline_rounded,
                  color: AppTheme.primaryColor, size: 60),
              const SizedBox(height: 16),
              if (showOrderInfo) CartPaymentSuccessDetailsSection(pro: pro),
              if (!showOrderInfo)
                Text(
                  '${'order_total'.tr()}: ${pro.orderBilling?.billingDetails.grandTotal}${pro.orderBilling?.billingDetails.currency}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  setState(() {
                    showOrderInfo = !showOrderInfo;
                  });
                },
                icon: Icon(
                    showOrderInfo
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    color: showOrderInfo
                        ? AppTheme.primaryColor
                        : ColorScheme.of(context).outlineVariant),
                label: Text(
                  showOrderInfo
                      ? 'hide_order_info'.tr()
                      : 'see_order_info'.tr(),
                  style: TextTheme.of(context).bodySmall?.copyWith(
                      color: showOrderInfo
                          ? AppTheme.primaryColor
                          : ColorScheme.of(context).outlineVariant),
                ),
              ),
              CustomElevatedButton(
                bgColor: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: ColorScheme.of(context).onSurface),
                textColor: ColorScheme.of(context).onSurface,
                onTap: () {
                  AppNavigator.pushNamedAndRemoveUntil(
                    DashboardScreen.routeName,
                    (_) => false,
                  );
                },
                title: 'continue'.tr(),
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartPaymentSuccessDetailsSection extends StatelessWidget {
  const CartPaymentSuccessDetailsSection({
    required this.pro,
    super.key,
  });

  final CartProvider pro;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${'order_total'.tr()}:${pro.orderBilling?.billingDetails.grandTotal}',
          style: TextTheme.of(context).titleSmall,
        ),
        InDevMode(child: AddressTile(address: pro.address!, onTap: () {})),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pro.cartItems.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderSuccessTile(
                  currency: pro.orderBilling?.billingDetails.currency ?? '',
                  item: pro.orderBilling?.items[index]);
            },
          ),
        )
      ],
    );
  }
}

class OrderSuccessTile extends StatelessWidget {
  const OrderSuccessTile({
    required this.item,
    required this.currency,
    super.key,
  });

  final OrderItemEntity? item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
              imageURL: item?.imageUrls.first,
              size: 60,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item?.name ?? '',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Quantity: ${item?.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                item?.price ?? '',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(currency.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }
}
