import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/checkout/checkout_address_section.dart';

class PersonalCheckoutView extends StatelessWidget {
  const PersonalCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ShadowContainer(
        padding: const EdgeInsets.all(0),
        child: Consumer<CartProvider>(
            builder: (BuildContext context, CartProvider cartPro, _) {
          return const Column(
            children: <Widget>[
              // if (cartPro.address != null)
              //   FutureBuilder<DataState<CheckOutEntity>>(
              //     future: cartPro.checkout(),
              //     builder: (
              //       BuildContext context,
              //       AsyncSnapshot<DataState<CheckOutEntity>> snapshot,
              //     ) {
              //       final CheckOutEntity checkout = snapshot.data?.entity ??
              //           CheckOutModel(items: <CheckOutItemEntity>[]);
              //       return Column(
              //         children: <Widget>[
              //           CheckoutListSection(
              //             checkOut: checkout,
              //             currency: checkout.currency,
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              CheckoutAddressSection(),
            ],
          );
        }),
      ),
    );
  }
}
