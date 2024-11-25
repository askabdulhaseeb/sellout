import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/shadow_container.dart';
import '../../../data/models/checkout/check_out_model.dart';
import '../../../domain/entities/checkout/check_out_entity.dart';
import '../../../domain/entities/checkout/check_out_item_entity.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/checkout/checkout_list_section.dart';

class PersonalCheckoutView extends StatelessWidget {
  const PersonalCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ShadowContainer(
        padding: const EdgeInsets.all(0),
        child: FutureBuilder<DataState<CheckOutEntity>>(
          future: Provider.of<CartProvider>(context, listen: false).checkout(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DataState<CheckOutEntity>> snapshot,
          ) {
            final CheckOutEntity checkout = snapshot.data?.entity ??
                CheckOutModel(items: <CheckOutItemEntity>[]);
            return Column(
              children: <Widget>[
                CheckoutListSection(
                  checkOut: checkout,
                  currency: checkout.currency,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}