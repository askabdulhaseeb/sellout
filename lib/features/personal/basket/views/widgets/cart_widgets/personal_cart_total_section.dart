import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../data/models/cart/add_shipping_response_model.dart';
import '../../../data/models/cart/cart_item_model.dart';
import '../../../data/sources/local/local_cart.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';
import '../../../domain/entities/cart/added_shipping_response_entity.dart';

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
          builder: (BuildContext context, CartProvider cartPro, _) {
            Future<String> calculateTotal(
                CartProvider cartPro, CartEntity cart) async {
              final double subtotal = await cart.cartTotalPrice();

              // Sum all shipping amounts for all items
              final double shippingTotal =
                  cartPro.addShippingResponse?.cart.cartItems.fold<double>(
                        0.0,
                        (double sum, AddShippingCartItemEntity item) =>
                            sum +
                            item.selectedShipping.fold<double>(
                              0.0,
                              (double innerSum, shipping) =>
                                  innerSum +
                                  (shipping.nativeBufferAmount),
                            ),
                      ) ??
                      0.0;

              final double total = subtotal + shippingTotal;

              return '${CountryHelper.currencySymbolHelper(LocalAuth.currency)}${total.toStringAsFixed(2)}';
            }

            if (cartPro.cartItems.isEmpty) return const SizedBox.shrink();
            final bool hasShipping =
                cartPro.addShippingResponse?.cart.cartItems.isNotEmpty == true;
            final bool isReviewOrder = cartPro.cartType == CartType.reviewOrder;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTile(
                  '${'subtotal'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
                  trailing: FutureBuilder<String>(
                    future: cart.cartTotalPriceString(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Text(
                        snapshot.data ?? '0.00',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      );
                    },
                  ),
                ),
                if (hasShipping && cartPro.cartType == CartType.reviewOrder)
                  _buildTile(
                    'delivery'.tr(),
                    trailing: Text(
                      '${CountryHelper.currencySymbolHelper(LocalAuth.currency)}'
                      '${cartPro.addShippingResponse!.cart.cartItems.fold<double>(
                            0.0,
                            (double sum, AddShippingCartItemEntity item) =>
                                sum +
                                item.selectedShipping.fold<double>(
                                  0.0,
                                  (double innerSum, shipping) =>
                                      innerSum +
                                      (shipping.nativeBufferAmount ),
                                ),
                          ).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                if (isReviewOrder && cartPro.cartType == CartType.reviewOrder)
                  _buildTile(
                    'total'.tr(),
                    trailing: FutureBuilder<String>(
                      future: calculateTotal(cartPro, cart),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        );
                      },
                    ),
                    bold: true,
                  ),
                CustomElevatedButton(
                  title: _getButtonTitle(cartPro.cartType),
                  isLoading: false,
                  isDisable: cartPro.cartType == CartType.checkoutOrder &&
                      cartPro.hasItemsRequiringRemoval,
                  onTap: () async => _handleButtonTap(context, cartPro, cart),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getButtonTitle(CartType type) {
    switch (type) {
      case CartType.shoppingBasket:
        return 'proceed_to_checkout'.tr();
      case CartType.checkoutOrder:
        return 'continue'.tr();
      case CartType.reviewOrder:
        return 'proceed_to_payment'.tr();
      case CartType.payment:
        return 'confirm_and_pay'.tr();
    }
  }

  Future<void> _handleButtonTap(
      BuildContext context, CartProvider cartPro, CartEntity cart) async {
    if (cartPro.cartType == CartType.shoppingBasket) {
      if (cartPro.cartItems.isNotEmpty) await cartPro.getRates();
      cartPro.setCartType(CartType.checkoutOrder);
      return;
    }

    if (cartPro.cartType == CartType.checkoutOrder) {
      if (cartPro.hasItemsRequiringRemoval) return;

      final bool fastDeliveryEmpty = cartPro.fastDeliveryProducts.isEmpty;
      final bool allFreeDelivery = cartPro.cartItems.isNotEmpty &&
          cartPro.cartItems.every((CartItemEntity item) {
            final PostEntity? post = LocalPost().post(item.postID);
            return post?.deliveryType == DeliveryType.freeDelivery;
          });

      if (fastDeliveryEmpty && allFreeDelivery) {
        cartPro.setCartType(CartType.reviewOrder);
        return;
      }

      final DataState<AddShippingResponseModel> result =
          await cartPro.submitShipping();
      if (result is DataSuccess<AddShippingResponseModel>) {
        final String? message = result.exception?.message;
        if (message != null && message.isNotEmpty) AppSnackBar.show(message);
        cartPro.setCartType(CartType.reviewOrder);
      } else if (context.mounted) {
        AppSnackBar.show(
            result.exception?.reason ?? 'failed_to_submit_shipping'.tr());
      }
      return;
    }

    if (cartPro.cartType == CartType.reviewOrder) {
      cartPro.setCartType(CartType.payment);
      return;
    }

    if (cartPro.cartType == CartType.payment) {
      await cartPro.processPayment(context);
    }
  }

  Widget _buildTile(String title, {Widget? trailing, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: 16),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
