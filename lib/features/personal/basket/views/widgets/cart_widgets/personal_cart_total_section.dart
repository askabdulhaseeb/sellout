import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/models/cart/cart_item_model.dart';
import '../../../data/sources/local/local_cart.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';
import '../../../domain/entities/cart/postage_detail_response_entity.dart';

class PersonalCartTotalSection extends StatelessWidget {
  const PersonalCartTotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<CartEntity>>(
      valueListenable: LocalCart().listenable(),
      builder: (BuildContext context, Box<CartEntity> box, _) {
        final CartEntity cart = box.values.firstWhere(
          (CartEntity element) => element.cartID == LocalAuth.uid,
          orElse: () => CartModel(),
        );
        return Consumer<CartProvider>(
          builder:
              (BuildContext context, CartProvider cartPro, Widget? child) =>
                  Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(),
              if (cartPro.cartType == CartType.shoppingBasket)
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  title: Text(
                    '${'subtotal'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
                  ),
                  trailing: Text(
                    cart.cartTotal.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              // When on the review step show a compact totals block above the
              // action button. Rendered by private widgets below for clarity.
              if (cartPro.cartType == CartType.reviewOrder) ...<Widget>[
                const SizedBox(height: 6),
                Builder(builder: (BuildContext context) {
                  final PostageDetailResponseEntity? postage =
                      cartPro.postageResponseEntity;
                  if (postage == null) return const SizedBox.shrink();
                  return _ReviewTotals._(
                    cart: cart,
                    postage: postage,
                  );
                }),
              ],

              CustomElevatedButton(
                title: cartPro.cartType == CartType.shoppingBasket
                    ? 'proceed_to_checkout'.tr()
                    : cartPro.cartType == CartType.checkoutOrder
                        ? 'continue'.tr()
                        : cartPro.cartType == CartType.reviewOrder
                            ? 'proceed_to_payment'.tr()
                            : cartPro.cartType == CartType.payment
                                ? 'confirm_and_pay'.tr().tr()
                                : '',
                isLoading: false,
                onTap: () async {
                  if (cartPro.cartType == CartType.shoppingBasket) {
                    //TODO: add cart page functionality
                    cartPro.setCartType(CartType.checkoutOrder);
                  } else if (cartPro.cartType == CartType.checkoutOrder) {
                    //TODO: add checkout page functionality
                    await cartPro.checkout();
                  } else if (cartPro.cartType == CartType.reviewOrder) {
                    //TODO: add review page functionality
                    cartPro.setCartType(CartType.payment);
                  } else if (cartPro.cartType == CartType.payment) {
                    //TODO: add payment page functionality
                    await cartPro.processPayment(context);
                  }
                },
              ),
              // (totals shown above button during review; nothing duplicated)
            ],
          ),
        );
      },
    );
  }
}

// Private widget: renders the three-row totals block for the review step.
class _ReviewTotals extends StatelessWidget {
  const _ReviewTotals._({required this.cart, required this.postage});

  final CartEntity cart;
  final PostageDetailResponseEntity postage;

  double _computePostageFee() {
    double postageFee = 0.0;
    try {
      for (final PostageItemDetailEntity e in postage.detail.values) {
        if (e.shippingDetails.isNotEmpty &&
            e.shippingDetails.first.ratesBuffered.isNotEmpty) {
          final RateEntity rate = e.shippingDetails.first.ratesBuffered.first;
          final String amtStr = rate.amountBuffered.isNotEmpty
              ? rate.amountBuffered
              : rate.amount;
          final double? parsed = double.tryParse(amtStr.replaceAll(',', ''));
          if (parsed != null) postageFee += parsed;
        }
      }
    } catch (_) {
      postageFee = 0.0;
    }
    return postageFee;
  }

  @override
  Widget build(BuildContext context) {
    final double postageFee = _computePostageFee();
    final double subtotal = cart.cartTotal;
    final double grandTotal = subtotal + postageFee;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _TotalsRow(
          title:
              '${'subtotal'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
          amount: subtotal,
        ),
        _TotalsRow(
          title: 'postage_fee'.tr(),
          amount: postageFee,
        ),
        _TotalsRow(
          title: 'total'.tr(),
          amount: grandTotal,
          isTotal: true,
        ),
      ],
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow(
      {required this.title, required this.amount, this.isTotal = false});

  final String title;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = isTotal
        ? Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.bodyMedium;
    final TextStyle amountStyle = isTotal
        ? Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700) ??
            const TextStyle(fontWeight: FontWeight.w700)
        : const TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

    return ListTile(
      minVerticalPadding: 0,
      dense: true,
      visualDensity: const VisualDensity(vertical: -3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      title: Text(title, style: titleStyle),
      trailing: Text(amount.toStringAsFixed(2), style: amountStyle),
    );
  }
}
