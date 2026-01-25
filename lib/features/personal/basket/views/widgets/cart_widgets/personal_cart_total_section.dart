import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
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
          builder: (BuildContext context, CartProvider cartPro, _) {
            if (cartPro.cartItems.isEmpty) return const SizedBox.shrink();
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (cartPro.cartType == CartType.shoppingBasket)
                    _buildTile(
                      '${'subtotal'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
                      trailing: FutureBuilder<String>(
                        future: cart.cartTotalPriceString(),
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<dynamic> snapshot,
                            ) => Text(
                              snapshot.data?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                      ),
                    ),
                  if (cartPro.cartType == CartType.reviewOrder)
                    Column(
                      children: <Widget>[
                        _buildTile(
                          '${'subtotal'.tr()} (${cartPro.orderBilling?.items.length} ${'items'.tr()})',
                          trailing: Text(
                            cartPro
                                    .orderBilling
                                    ?.billingDetails
                                    .subTotalPriceString ??
                                '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _buildTile(
                          'delivery'.tr(),
                          trailing: Text(
                            cartPro
                                    .orderBilling
                                    ?.billingDetails
                                    .deliveryPriceString ??
                                '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        _buildTile(
                          'total'.tr(),
                          trailing: Text(
                            cartPro
                                    .orderBilling
                                    ?.billingDetails
                                    .totalPriceString ??
                                '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  CustomElevatedButton(
                    title: _getButtonTitle(cartPro.cartType),
                    isLoading: cartPro.loadingPostage,
                    isDisable:
                        (cartPro.cartType == CartType.checkoutOrder &&
                            cartPro.hasItemsRequiringRemoval) ||
                        (cartPro.cartType == CartType.checkoutOrder &&
                            cartPro.hasAnyPickupItems() &&
                            !cartPro.hasAllPickupItemsWithServicePoints()),
                    onTap: () async => _handleButtonTap(context, cartPro, cart),
                  ),
                ],
              ),
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
        return 'get_shipping_options'.tr();
      case CartType.reviewOrder:
        return 'proceed_to_payment'.tr();
      case CartType.payment:
        return 'confirm_and_pay'.tr();
    }
  }

  Future<void> _handleButtonTap(
    BuildContext context,
    CartProvider cartPro,
    CartEntity cart,
  ) async {
    if (cartPro.cartType == CartType.shoppingBasket) {
      cartPro.setCartType(CartType.checkoutOrder);
      return;
    }

    if (cartPro.cartType == CartType.checkoutOrder) {
      if (cartPro.hasItemsRequiringRemoval) return;

      // Check if any items are set to pickup but don't have service points selected
      if (cartPro.hasAnyPickupItems() &&
          !cartPro.hasAllPickupItemsWithServicePoints()) {
        if (context.mounted) {
          AppSnackBar.show(
            'Please select a pickup location for all pickup items'.tr(),
          );
        }
        return;
      }

      // Call getRates to fetch postage details with delivery preferences
      final DataState<dynamic> ratesResult = await cartPro.getRates();
      if (ratesResult is! DataSuccess) {
        if (context.mounted) {
          AppSnackBar.show(
            ratesResult.exception?.reason ?? 'failed_to_get_postage'.tr(),
          );
        }
        return;
      }

      // Show postage bottomsheet to let user select rates
      if (context.mounted) {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const PostageBottomSheet(),
        );
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
              fontSize: 16,
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
