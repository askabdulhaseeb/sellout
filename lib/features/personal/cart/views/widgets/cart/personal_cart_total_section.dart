import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../data/models/cart/cart_item_model.dart';
import '../../../data/sources/local_cart.dart';
import '../../providers/cart_provider.dart';

class PersonalCartTotalSection extends StatelessWidget {
  const PersonalCartTotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<CartEntity>>(
      valueListenable: LocalCart().listenable(),
      builder: (BuildContext context, Box<CartEntity> box, _) {
        final CartEntity cart = box.values.firstWhere(
          (CartEntity element) => element.cartID == LocalAuth.uid,
          orElse: () => CartModel(),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              const Divider(),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Text(
                  '${'total'.tr()} (${cart.cartItems.length} ${'items'.tr()})',
                ),
                trailing: Text(
                  cart.cartTotal.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              CustomElevatedButton(
                title: 'proceed_to_checkout'.tr(),
                isLoading: false,
                onTap: () =>
                    Provider.of<CartProvider>(context, listen: false).page = 2,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
