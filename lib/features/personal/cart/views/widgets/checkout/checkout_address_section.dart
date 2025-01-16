import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../core/bottom_sheets/widgets/address_tile.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../providers/cart_provider.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider cartPro, _) {
        final AddressEntity? address = cartPro.address;
        return address == null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('no_address').tr(),
                    CustomElevatedButton(
                      onTap: () async => onTap(context, cartPro),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: 'select_address'.tr(),
                      isLoading: false,
                    ),
                  ],
                ),
              )
            : AddressTile(
                address: address,
                onTap: () async => onTap(context, cartPro),
              );
      },
    );
  }

  Future<void> onTap(BuildContext context, CartProvider cartPro) async {
    final AddressEntity? newAddress =
        await showModalBottomSheet<AddressEntity?>(
      context: context,
      builder: (BuildContext context) {
        return AddressBottomSheet(initAddress: cartPro.address);
      },
    );
    if (newAddress != null) {
      cartPro.address = newAddress;
    }
  }
}
