import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_spacings.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../marketplace/views/screens/pages/buy_again_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/shopping_basket_tabbar.dart';
import 'saved_later/personal_cart_save_later_item_list.dart';
import 'shopping/personal_shopping_page.dart';
import '../../domain/enums/shopping_basket_type.dart';

class PersonalShoppingBasketScreen extends StatefulWidget {
  const PersonalShoppingBasketScreen({super.key});
  static const String routeName = '/cart';

  @override
  State<PersonalShoppingBasketScreen> createState() =>
      _PersonalShoppingBasketScreenState();
}

class _PersonalShoppingBasketScreenState
    extends State<PersonalShoppingBasketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getCart(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(' token ${LocalAuth.token}');
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) =>
          context.read<CartProvider>().reset(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const AppBarTitle(titleKey: 'shopping_basket'),
        ),
        body: PopScope(
          onPopInvokedWithResult: (bool didPop, dynamic result) =>
              context.read<CartProvider>().reset(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Consumer<CartProvider>(
              builder: (BuildContext context, CartProvider cartPro, _) {
                return Column(
                  children: <Widget>[
                    const PersonalShoppingTabbar(),
                    if (cartPro.shoppingBasketType ==
                        ShoppingBasketPageType.basket)
                      const Expanded(child: PersonalShoppingPage())
                    else if (cartPro.shoppingBasketType ==
                        ShoppingBasketPageType.saved)
                      const Expanded(child: PersonalCartSaveLaterItemList())
                    else if (cartPro.shoppingBasketType ==
                        ShoppingBasketPageType.buyAgain)
                      const Expanded(child: BuyAgainSection())
                    else
                      const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
