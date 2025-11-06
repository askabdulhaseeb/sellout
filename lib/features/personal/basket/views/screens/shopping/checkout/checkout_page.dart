import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../auth/signin/data/models/address_model.dart';
import '../../../providers/cart_provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.read<CartProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () async {
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
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: ColorScheme.of(context).outlineVariant),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${'post_to'.tr()}:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cartPro.address?.address ?? 'no_address'.tr(),
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (cartPro.address != null) ...<Widget>[
                              const SizedBox(height: 2),
                              Text(
                                '${cartPro.address!.townCity}\n${cartPro.address!.country}\n${cartPro.address!.postalCode}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InDevMode(
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: ColorScheme.of(context).outlineVariant),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${'payment_method'.tr()}:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  // small payment icon placeholder
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.apple,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('x-7655'),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

// class PersonalCheckoutView extends StatelessWidget {
//   const PersonalCheckoutView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: ColorScheme.of(context).outlineVariant),
//           borderRadius: BorderRadius.circular(8)),
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: Consumer<CartProvider>(
//           builder: (BuildContext context, CartProvider cartPro, _) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             if (cartPro.address != null)
//               FutureBuilder<DataState<CheckOutEntity>>(
//                 future: cartPro.checkout(),
//                 builder: (
//                   BuildContext context,
//                   AsyncSnapshot<DataState<CheckOutEntity>> snapshot,
//                 ) {
//                   final CheckOutEntity checkout = snapshot.data?.entity ??
//                       CheckOutModel(items: <CheckOutItemEntity>[]);
//                   return Column(
//                     children: <Widget>[
//                       CheckoutListSection(
//                         checkOut: checkout,
//                         currency: checkout.currency,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             const CheckoutAddressSection(),
//           ],
//         );
//       }),
//     );
//   }
// }
