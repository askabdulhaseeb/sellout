import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../widgets/checkout/tile/payment_success_bottomsheet.dart';
import 'checkout/personal_checkout_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_widgets/cart_save_later_toggle_section.dart';
import '../widgets/cart_widgets/personal_cart_total_section.dart';
import 'cart_screens/personal_cart_cart_item_list.dart';
import '../widgets/cart_widgets/personal_cart_page_tile.dart';
import 'cart_screens/personal_cart_save_later_item_list.dart';

class PersonalCartScreen extends StatelessWidget {
  const PersonalCartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final CartProvider pro = Provider.of<CartProvider>(context, listen: false);
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => pro.reset(),
      child: Scaffold(
        appBar: AppBar(
            // leading: BackButton(
            //   onPressed: () {
            //     AppNavigator.pushNamedAndRemoveUntil(
            //         DashboardScreen.routeName, (_) => false);
            //   },
            // ),
            title: const Text('cart').tr()),
        body: Consumer<CartProvider>(
            builder: (BuildContext context, CartProvider cartPro, _) {
          return FutureBuilder<bool>(
            future: cartPro.getCart(),
            builder: (BuildContext context, AsyncSnapshot<bool> snap) {
              return Column(
                children: <Widget>[
                  const PersonalCartPageTile(),
                  const SizedBox(height: 24),
                  cartPro.page == 1
                      ? Expanded(
                          child: Column(
                            children: <Widget>[
                              const CartSaveLaterToggleSection(),
                              cartPro.basketPage == CartItemType.cart
                                  ? const PersonalCartItemList()
                                  : const PersonalCartSaveLaterItemList(),
                              if (cartPro.basketPage == CartItemType.cart)
                                const PersonalCartTotalSection(),
                            ],
                          ),
                        )
                      : cartPro.page == 2
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: <Widget>[
                                    const PersonalCheckoutView(),
                                    const Spacer(),
                                    CustomElevatedButton(
                                      title: 'proceed_to_payment'.tr(),
                                      isLoading: false,
                                      onTap: () async {
                                        final CartProvider pro =
                                            Provider.of<CartProvider>(context,
                                                listen: false);
                                        final DataState<PaymentIntent> result =
                                            await pro.processPayment();
                                        if (result is DataSuccess) {
                                          // 🎉 Payment succeeded → Show success bottom sheet
                                          if (context.mounted) {
                                            showModalBottomSheet(
                                              useSafeArea: true,
                                              isScrollControlled: true,
                                              context: context,
                                              enableDrag: false,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              builder: (_) =>
                                                  const PaymentSuccessSheet(),
                                            );
                                          }
                                        } else if (result is DataFailer) {
                                          // ❌ Payment failed → Show error
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${'payment_failed'.tr()}: ${result.exception?.toString()}'),
                                                backgroundColor:
                                                    ColorScheme.of(context)
                                                        .error,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            )
                          // : cartPro.page == 3
                          //     ? const CheckoutPaymentMethodSection()
                          : const SizedBox.shrink()
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
