import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart_widgets/personal_cart_step_indicator.dart';
import '../../widgets/cart_widgets/personal_cart_total_section.dart';
import 'cart/cart_page.dart';
import 'checkout/checkout_page.dart';

class PersonalShoppingPage extends StatefulWidget {
  const PersonalShoppingPage({super.key});

  @override
  State<PersonalShoppingPage> createState() => _PersonalShoppingPageState();
}

class _PersonalShoppingPageState extends State<PersonalShoppingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(' token ${LocalAuth.token}');
    final CartProvider cartPro = context.watch<CartProvider>();

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          context.read<CartProvider>().reset(),
      child: cartPro.cartItems.isEmpty
          ? const EmptyPageWidget(icon: Icons.shopping_cart_outlined)
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const PersonalCartStepIndicator(),
                const SizedBox(height: 24),
                Expanded(
                  child: Builder(builder: (BuildContext context) {
                    if (cartPro.page == 1) return const CartPage();
                    if (cartPro.page == 2) return const CheckoutPage();
                    if (cartPro.page == 3) {
                      return const Center(child: Text('Order Review'));
                    }
                    if (cartPro.page == 4) {
                      return const Center(child: Text('Payment'));
                    }
                    return const SizedBox.shrink();
                  }),
                ),
                const PersonalCartTotalSection(),
              ],
            ),
    );
  }
}
