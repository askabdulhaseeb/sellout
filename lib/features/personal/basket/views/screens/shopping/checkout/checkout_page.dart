import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../core/bottom_sheets/postage/postage_bottom_sheet.dart';
import '../../../../../auth/signin/data/models/address_model.dart';
import '../../../../domain/entities/cart/postage_detail_response_entity.dart';
import '../../../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final CartProvider cartPro = context.read<CartProvider>();
      if (cartPro.address != null && cartPro.postageResponseEntity == null) {
        cartPro.checkout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            final AddressEntity? newAddress =
                await showModalBottomSheet<AddressEntity>(
              context: context,
              builder: (BuildContext context) {
                return AddressBottomSheet(initAddress: cartPro.address);
              },
            );
            if (newAddress != null) {
              cartPro.address = newAddress;
              await cartPro.checkout();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorScheme.of(context).outlineVariant,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                          color: Theme.of(context).textTheme.bodyMedium!.color,
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
                          '${cartPro.address!.city}\n'
                          '${cartPro.address!.state.stateName}\n'
                          '${cartPro.address!.country.displayName}\n'
                          '${cartPro.address!.postalCode}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ]
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            // Ensure postage details are available before opening sheet
            if (cartPro.postageResponseEntity == null) {
              await cartPro.checkout();
            }
            if (cartPro.postageResponseEntity == null) return;
            final Map<String, RateEntity>? newSelection =
                await showModalBottomSheet<Map<String, RateEntity>>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return PostageBottomSheet(
                    postage: cartPro.postageResponseEntity!);
              },
            );

            // PostageBottomSheet updates provider when Apply is pressed.
            // If a selection map is returned, refresh local UI.
            if (newSelection != null) {
              setState(() {});
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorScheme.of(context).outlineVariant,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${'postage'.tr()}:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (cartPro.postageResponseEntity != null) ...<Widget>[
                        Text('choose_shipping_service'.tr(),
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 6),
                        if (cartPro.selectedPostageRates.isNotEmpty)
                          Builder(builder: (context) {
                            // Calculate total from selected rates defensively
                            double total = 0.0;
                            for (final RateEntity rate
                                in cartPro.selectedPostageRates.values) {
                              String candidate = rate.amountBuffered.isNotEmpty
                                  ? rate.amountBuffered
                                  : rate.amount;
                              // Remove any non-numeric characters except dot and minus
                              final cleaned =
                                  candidate.replaceAll(RegExp(r"[^0-9.-]"), '');
                              final parsed = double.tryParse(cleaned);
                              if (parsed != null) total += parsed;
                            }

                            return Text(
                              '${cartPro.selectedPostageRates.length} selected • total ${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 13),
                            );
                          }),
                      ]
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
