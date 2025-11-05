import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_widgets/cart_save_later_toggle_section.dart';
import '../widgets/cart_widgets/personal_cart_page_tile.dart';
import '../widgets/cart_widgets/personal_cart_total_section.dart';
import 'cart_pages/personal_cart_cart_item_list.dart';
import 'cart_pages/personal_cart_save_later_item_list.dart';
import 'checkout/personal_checkout_screen.dart';

class PersonalCartScreen extends StatefulWidget {
  const PersonalCartScreen({super.key});
  static const String routeName = '/cart';

  @override
  State<PersonalCartScreen> createState() => _PersonalCartScreenState();
}

class _PersonalCartScreenState extends State<PersonalCartScreen> {
  @override
  void initState() {
    super.initState();
    // Defer provider calls until after first frame to avoid using context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(' token ${LocalAuth.token}');
    // watch for reactive updates to cart provider
    final CartProvider cartPro = context.watch<CartProvider>();

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          context.read<CartProvider>().reset(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle(titleKey: 'cart'),
        ),
        body: PopScope(
          onPopInvokedWithResult: (bool didPop, dynamic result) =>
              context.read<CartProvider>().reset(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const PersonalCartPageTile(),
                const SizedBox(height: 24),
                if (cartPro.page == 1)
                  const CartPage()
                else if (cartPro.page == 2)
                  const CheckoutPage()
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    return Expanded(
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
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const PersonalCheckoutView(),
            CustomElevatedButton(
              title: 'proceed_to_payment'.tr(),
              isLoading: false,
              onTap: () async {
                await cartPro.processPayment(context);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
