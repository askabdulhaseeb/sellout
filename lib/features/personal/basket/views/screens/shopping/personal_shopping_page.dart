import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart_widgets/personal_cart_step_indicator.dart';
import '../../widgets/cart_widgets/personal_cart_total_section.dart';
import 'cart/cart_page.dart';
import 'checkout/checkout_page.dart';
import 'payment/payment_page.dart';
import 'review/review_page.dart';

class PersonalShoppingPage extends StatefulWidget {
  const PersonalShoppingPage({super.key});

  @override
  State<PersonalShoppingPage> createState() => _PersonalShoppingPageState();
}

void _clearCartCheckoutState(BuildContext context) {
  final cartPro = Provider.of<CartProvider>(context, listen: false);
  cartPro.clearRatesAndCheckout();
}

@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      _clearCartCheckoutState(context);
      return true;
    },
    child: PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          context.read<CartProvider>().reset(),
      child: Builder(
        builder: (BuildContext context) {
          final CartProvider cartPro = context.watch<CartProvider>();
          if (cartPro.cartItems.isEmpty) {
            return const EmptyPageWidget(icon: Icons.shopping_cart_outlined);
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const PersonalCartStepIndicator(),
                const SizedBox(height: 24),
                Expanded(
                  child: Builder(builder: (BuildContext context) {
                    if (cartPro.cartType == CartType.shoppingBasket) {
                      return const CartPage();
                    } else if (cartPro.cartType == CartType.checkoutOrder) {
                      return const CheckoutPage();
                    } else if (cartPro.cartType == CartType.reviewOrder) {
                      return const ReviewCartPage();
                    } else if (cartPro.cartType == CartType.payment) {
                      return const CartPaymentPage();
                    }
                    return const SizedBox.shrink();
                  }),
                ),
                const PersonalCartTotalSection(),
              ],
            );
          }
        },
      ),
    ),
  );
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
                    if (cartPro.cartType == CartType.shoppingBasket) {
                      return const CartPage();
                    } else if (cartPro.cartType == CartType.checkoutOrder) {
                      return const CheckoutPage();
                    } else if (cartPro.cartType == CartType.reviewOrder) {
                      return const ReviewCartPage();
                    } else if (cartPro.cartType == CartType.payment) {
                      return const CartPaymentPage();
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
