import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_widgets/cart_save_later_toggle_section.dart';
import '../widgets/cart_widgets/personal_cart_page_tile.dart';
import '../widgets/cart_widgets/personal_cart_total_section.dart';
import 'cart_screens/personal_cart_cart_item_list.dart';
import 'cart_screens/personal_cart_save_later_item_list.dart';
import 'checkout/personal_checkout_screen.dart';

class PersonalCartScreen extends StatelessWidget {
  const PersonalCartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final CartProvider pro = Provider.of<CartProvider>(context, listen: false);
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => pro.reset(),
      child: Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartPro, Widget? child) =>
            Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const AppBarTitle(titleKey: 'cart'),
                ),
                body: PopScope(
                  onPopInvokedWithResult: (bool didPop, dynamic result) =>
                      pro.reset(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const PersonalCheckoutView(),
                                          CustomElevatedButton(
                                            title: 'proceed_to_payment'.tr(),
                                            isLoading: false,
                                            onTap: () async {
                                              await cartPro
                                                  .processPayment(context);
                                            },
                                          ),
                                          const SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
