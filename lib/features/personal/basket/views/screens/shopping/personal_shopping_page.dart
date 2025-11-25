import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../core/widgets/empty_page_widget.dart';
import '../../../data/sources/local/local_cart.dart';
import '../../../domain/enums/cart_type.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart_widgets/personal_cart_step_indicator.dart';
import '../../widgets/cart_widgets/personal_cart_total_section.dart';
import 'cart/cart_page.dart';
import 'checkout/checkout_page.dart';
import 'cart_payment/cart_payment_page.dart';
import 'cart_review/cart_review_page.dart';

class PersonalShoppingPage extends HookWidget {
  const PersonalShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CartProvider>().getCart();
      });
      return null;
    }, <Object?>[]);
    useValueListenable(LocalCart().listenable());
    final String uid = LocalAuth.uid ?? '';
    final CartEntity cartEntity = LocalCart().entity(uid);
    final List<CartItemEntity> allItems = cartEntity.cartItems;
    final CartProvider cartPro = context.watch<CartProvider>();
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          context.read<CartProvider>().reset(),
      child: allItems.isEmpty
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
                if (allItems.isNotEmpty) const PersonalCartTotalSection(),
              ],
            ),
    );
  }
}
