import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../providers/cart_provider.dart';

class CartSaveLaterToggleSection extends StatelessWidget {
  const CartSaveLaterToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (
      BuildContext context,
      CartProvider cartPro,
      _,
    ) {
      return CustomToggleSwitch<CartItemType>(
        labels: CartItemType.list,
        onToggle: (CartItemType value) => cartPro.basketPage = value,
        initialValue: cartPro.basketPage,
        labelStrs: CartItemType.codeList.map((String e) => e.tr()).toList(),
        labelText: '',
      );
    });
  }
}
