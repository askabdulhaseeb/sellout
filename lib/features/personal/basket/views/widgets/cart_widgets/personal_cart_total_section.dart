import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
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
import '../../../domain/entities/checkout/payment_intent_entity.dart';
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
          builder: (BuildContext context, CartProvider cartPro, _) {
            if (cartPro.cartItems.isEmpty) return const SizedBox.shrink();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (cartPro.cartType == CartType.shoppingBasket)
                  _buildTile(
                      '${'subtotal'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
                      trailing: FutureBuilder<String>(
                        future: cart.cartTotalPriceString(),
                        builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) =>
                            Text(
                          snapshot.data?.toString() ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      )),
                if (cartPro.cartType == CartType.reviewOrder)
                  Column(
                    children: <Widget>[
                      _buildTile(
                        '${'subtotal'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
                        trailing: Text(
                          cartPro.orderBilling?.billingDetails
                                  .deliveryPriceString ??
                              '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      _buildTile(
                        'delivery'.tr(),
                        trailing: Text(
                          cartPro.orderBilling?.billingDetails
                                  .deliveryPriceString ??
                              '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      _buildTile(
                        'total'.tr(),
                        trailing: Text(
                          cartPro.orderBilling?.billingDetails
                                  .totalPriceString ??
                              '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
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
        final DataState<PaymentIntentEntity> billingResult =
            await cartPro.getBillingDetails();
        if (billingResult is DataSuccess) {
          cartPro.setCartType(CartType.reviewOrder);
        }
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
