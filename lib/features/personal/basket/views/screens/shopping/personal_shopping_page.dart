import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart_widgets/personal_cart_step_indicator.dart';
import 'cart/cart_page.dart';
import 'checkout/personal_checkout_screen.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // This widget is placed inside a parent that provides removing MainAxisSize.min  will cause a layout error
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const PersonalCartStepIndicator(),
            const SizedBox(height: 24),
            if (cartPro.page == 1)
              const CartPage()
            else if (cartPro.page == 2)
              const CheckoutPage()
            else if (cartPro.page == 3)
              const Center(
                child: Text('Order Review'),
              )
            else if (cartPro.page == 4)
              const Center(
                child: Text('Payment'),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
