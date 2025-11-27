import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../domain/entities/checkout/billing_details_entity.dart';
import '../../../../domain/entities/checkout/payment_item_entity.dart';
import '../../../providers/cart_provider.dart';

class PaymentSuccessSheet extends StatefulWidget {
  const PaymentSuccessSheet({super.key});

  @override
  State<PaymentSuccessSheet> createState() => _PaymentSuccessSheetState();
}

class _PaymentSuccessSheetState extends State<PaymentSuccessSheet>
    with SingleTickerProviderStateMixin {
  bool showOrderInfo = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider pro = Provider.of<CartProvider>(context, listen: false);
    final BillingDetailsEntity? billing = pro.orderBilling?.billingDetails;

    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 150),
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
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Icon(Icons.check_circle_outline_rounded,
                    color: Theme.of(context).primaryColor, size: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                textAlign: TextAlign.center,
                'payment_successful_description'.tr(),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
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
                      ? Theme.of(context).primaryColor
                      : ColorScheme.of(context).outline),
              label: Text(
                showOrderInfo ? 'hide_order_info'.tr() : 'see_order_info'.tr(),
                style: TextTheme.of(context).bodySmall?.copyWith(
                    color: showOrderInfo
                        ? Theme.of(context).primaryColor
                        : ColorScheme.of(context).outline),
              ),
            ),
            if (showOrderInfo) CartPaymentSuccessDetailsSection(pro: pro),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${'order_total'.tr()}: ${CountryHelper.currencySymbolHelper(billing?.currency)}${billing?.grandTotal ?? ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            CustomElevatedButton(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'continue'.tr(),
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAddressSection extends StatelessWidget {
  const _CustomAddressSection({
    required this.name,
    required this.street,
    required this.city,
    required this.country,
  });
  final String name;
  final String street;
  final String city;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${'post_to'.tr()}:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(street),
        Text(city),
        Text(country),
      ],
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
    final BillingDetailsEntity? billing = pro.orderBilling?.billingDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _CustomAddressSection(
          name: pro.address?.address1 ?? '',
          street: pro.address?.city ?? '',
          city: pro.address?.state?.stateName ?? '',
          country: pro.address?.country.countryName ?? '',
        ),
        const SizedBox(height: 6),
        Text(
          '${'items'.tr()}:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pro.cartItems.length,
          itemBuilder: (BuildContext context, int index) {
            return OrderSuccessTile(
              currency: billing?.currency ?? '',
              item: pro.orderBilling?.items[index],
            );
          },
        ),
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

  final PaymentItemEntity? item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
              imageURL: item?.imageUrls.isNotEmpty == true
                  ? item!.imageUrls.first
                  : '',
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
                  'Quantity: ${item?.quantity ?? 0}',
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
                '${CountryHelper.currencySymbolHelper(currency)}${item?.totalPrice}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
