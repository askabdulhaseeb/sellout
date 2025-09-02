import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../domain/enums/basket_type.dart';
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
                )),
      ),
    );
  }
}

class PersonalBasketSection extends StatelessWidget {
  const PersonalBasketSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider pro, Widget? child) =>
          Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: <Widget>[
            const PersonalCartPageTile(),
            if (pro.basketType == BasketType.shoppingBasket)
              const BasketItemListPage()
          ],
        ),
      ),
    );
  }
}

class BasketItemListPage extends StatelessWidget {
  const BasketItemListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            //TODO: delete all items from cart functionality
          },
          child: Text(
            'deselect_all_items'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.primaryColor),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
        const PersonalCartItemList(), //is a listviewbuilder in a sizedbox
        Container(
          //need to be attached to bottom
          padding: const EdgeInsets.all(16),
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InDevMode(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('delivery'.tr()), const Text('free')],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'subtotal'.tr(),
                    style: TextTheme.of(context)
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Text('j'),
                ],
              ),
              CustomElevatedButton(
                  title: 'proceed_to_checkout'.tr(),
                  isLoading: false,
                  onTap: () {})
            ],
          ),
        ),
      ],
    );
  }
}
