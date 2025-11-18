import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/models/cart/add_shipping_response_model.dart';
import '../../../data/models/cart/cart_item_model.dart';
import '../../../data/sources/local/local_cart.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';

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
              if (cartPro.cartType == CartType.shoppingBasket &&
                  cartPro.cartItems
                      .map((CartItemEntity e) =>
                          e.status == CartItemStatusType.cart)
                      .isNotEmpty)
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
                isDisable: cartPro.cartType == CartType.checkoutOrder &&
                    cartPro.hasItemsRequiringRemoval,
                onTap: () async {
                  if (cartPro.cartType == CartType.shoppingBasket) {
                    if (cartPro.cartItems.isNotEmpty) await cartPro.getRates();
                    cartPro.setCartType(CartType.checkoutOrder);
                  } else if (cartPro.cartType == CartType.checkoutOrder) {
                    if (cartPro.hasItemsRequiringRemoval) {
                      // Do nothing; button disabled visually.
                      return;
                    }

                    // Submit shipping selection to API
                    final DataState<AddShippingResponseModel> result =
                        await cartPro.submitShipping();

                    if (result is DataSuccess<AddShippingResponseModel>) {
                      // Move to review order after successful API call
                      final String? message = result.entity?.message;
                      if (message != null && message.isNotEmpty) {
                        AppSnackBar.show(message);
                      }
                      cartPro.setCartType(CartType.reviewOrder);
                    } else {
                      // Show error message
                      if (context.mounted) {
                        AppSnackBar.show(
                          result.exception?.reason ??
                              'failed_to_submit_shipping'.tr(),
                        );
                      }
                    }
                  } else if (cartPro.cartType == CartType.reviewOrder) {
                    cartPro.setCartType(CartType.payment);
                  } else if (cartPro.cartType == CartType.payment) {
                    await cartPro.processPayment(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
