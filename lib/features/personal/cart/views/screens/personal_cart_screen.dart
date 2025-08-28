import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../domain/enums/cart_type.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_tab_selection_widget.dart';
import '../widgets/cart_widgets/personal_cart_page_tile.dart';
import 'cart_screens/personal_cart_cart_item_list.dart';

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
                body: Column(
                  children: <Widget>[
                    const CartTabSelectionWidget(),
                    if (pro.cartType == CartType.basket)
                      const PersonalBasketSection(),
                    if (pro.cartType == CartType.buyAgain)
                      const Text('bbbbbbbbbbbbbbbbbbbbbbbbbbbb'),
                    if (pro.cartType == CartType.saved)
                      const Text('cccccccccccc')
                  ],
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
          const Column(
        children: <Widget>[PersonalCartPageTile(), BasketItemListPage()],
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
    return const PersonalCartItemList();
  }
}
