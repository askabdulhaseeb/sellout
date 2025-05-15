import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../widgets/checkout/checkout_payment_method_section.dart';
import 'checkout/personal_checkout_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart/cart_save_later_toggle_section.dart';
import '../widgets/cart/personal_cart_total_section.dart';
import 'cart/personal_cart_cart_item_list.dart';
import '../widgets/cart/personal_cart_page_tile.dart';
import 'cart/personal_cart_save_later_item_list.dart';

class PersonalCartScreen extends StatelessWidget {
  const PersonalCartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('cart').tr()),
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
                                      onTap: () {
                                        CartProvider pro =
                                            Provider.of<CartProvider>(context,
                                                listen: false);
                                        pro.page = 3;
                                      }),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          )
                        : cartPro.page == 3
                            ? const CheckoutPaymentMethodSection()
                            : const SizedBox.shrink()
              ],
            );
          },
        );
      }),
    );
  }
}
