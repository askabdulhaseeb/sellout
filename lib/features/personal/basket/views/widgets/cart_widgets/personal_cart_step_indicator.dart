import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';

class PersonalCartStepIndicator extends StatelessWidget {
  const PersonalCartStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartPro, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _IconButton(
              title: 'shopping_basket'.tr(),
              isActive: cartPro.cartType == CartType.shoppingBasket,
              onTap: () {
                // allow going back to shopping basket only if we're past it
                if (cartPro.cartType.index > CartType.shoppingBasket.index) {
                  cartPro.setCartType(CartType.shoppingBasket);
                }
              },
            ),
          ),
          Expanded(
            child: _IconButton(
              title: 'checkout'.tr(),
              isActive: cartPro.cartType == CartType.checkoutOrder,
              onTap: () {
                // allow going back to checkout only if we're past it
                if (cartPro.cartType.index > CartType.checkoutOrder.index) {
                  cartPro.setCartType(CartType.checkoutOrder);
                }
              },
            ),
          ),
          Expanded(
            child: _IconButton(
              title: 'review_order'.tr(),
              isActive: cartPro.cartType == CartType.reviewOrder,
              onTap: () {
                // allow going back to review only if we're past it
                if (cartPro.cartType.index > CartType.reviewOrder.index) {
                  cartPro.setCartType(CartType.reviewOrder);
                }
              },
            ),
          ),
          Expanded(
            child: _IconButton(
              title: 'payment'.tr(),
              isActive: cartPro.cartType == CartType.payment,
              onTap: () {
                // allow going back to payment only if we're past it (no-op in normal flow)
                if (cartPro.cartType.index > CartType.payment.index) {
                  cartPro.setCartType(CartType.payment);
                }
              },
            ),
          ),
        ],
      );
    });
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline_sharp,
                color: color,
                size: AppSpacing.md,
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
