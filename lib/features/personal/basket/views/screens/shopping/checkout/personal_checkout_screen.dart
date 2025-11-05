import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../data/models/checkout/check_out_model.dart';
import '../../../../domain/entities/checkout/check_out_entity.dart';
import '../../../../domain/entities/checkout/check_out_item_entity.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/checkout/checkout_address_section.dart';
import '../../../widgets/checkout/checkout_list_section.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // const PersonalCheckoutView(),
        Column(
          children: <Widget>[
            CustomElevatedButton(
              title: 'proceed_to_payment'.tr(),
              isLoading: false,
              onTap: () async {
                await cartPro.processPayment(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class PersonalCheckoutView extends StatelessWidget {
  const PersonalCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ColorScheme.of(context).outlineVariant),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Consumer<CartProvider>(
          builder: (BuildContext context, CartProvider cartPro, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (cartPro.address != null)
              FutureBuilder<DataState<CheckOutEntity>>(
                future: cartPro.checkout(),
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
            const CheckoutAddressSection(),
          ],
        );
      }),
    );
  }
}
