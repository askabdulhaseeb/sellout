import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../data/models/cart/cart_item_model.dart';
import '../../../../../data/sources/local/local_cart.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../widgets/cart_widgets/tile/personal_cart_tile.dart';

class PersonalCartItemList extends HookWidget {
  const PersonalCartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = useMemoized(() => LocalAuth.uid ?? '', <Object?>[]);
    final CartProvider cartProvider = useProvider<CartProvider>();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cartProvider.getCart(forceRefresh: true);
      });
      return null;
    }, <Object?>[]);

    final Box<CartEntity> cartBox =
        useValueListenable(LocalCart().listenable());

    final CartEntity cart = cartBox.values.firstWhere(
      (CartEntity element) => element.cartID == uid,
      orElse: () => CartModel(),
    );

    final List<CartItemEntity> cartItems = cart.cartItems;

    if (cartItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await cartProvider.getCart(forceRefresh: true);
      },
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
            Divider(color: Theme.of(context).dividerColor),
        padding: const EdgeInsets.symmetric(vertical: 8),
        shrinkWrap: true,
        primary: false,
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final CartItemEntity item = cartItems[index];
          return PersonalCartTile(
            key: ValueKey<String>('cart_item_${item.cartItemID}'),
            item: item,
          );
        },
      ),
    );
  }
}

T useProvider<T>() {
  final BuildContext context = useContext();
  return Provider.of<T>(context, listen: false);
}
