import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../auth/signin/data/models/address_model.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../../../basket/views/providers/cart_provider.dart';
import '../../../../../../../post/domain/params/offer_payment_params.dart';
import '../../../../../../../post/domain/usecase/offer_payment_usecase.dart';

class OfferBuyNowButton extends StatelessWidget {
  const OfferBuyNowButton({required this.offerId, super.key});
  final String offerId;

  AddressEntity? get address {
    final List<AddressEntity>? userAddresses = LocalAuth.currentUser?.address;
    if (userAddresses != null &&
        userAddresses.where((AddressEntity e) => e.isDefault).isNotEmpty) {
      return userAddresses.firstWhere((AddressEntity e) => e.isDefault);
    }
    return null;
  }

  Future<void> _selectAddress(
      BuildContext context, CartProvider cartPro) async {
    final AddressEntity? selectedAddress =
        await showModalBottomSheet<AddressEntity?>(
      context: context,
      builder: (BuildContext context) =>
          AddressBottomSheet(initAddress: cartPro.address),
    );
    if (selectedAddress != null) {
      cartPro.setAddress(selectedAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<CartProvider>(
        builder: (BuildContext context, CartProvider cartPro, _) {
          return CustomElevatedButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            borderRadius: BorderRadius.circular(6),
            title: 'buy_now'.tr(),
            isLoading: false,
            onTap: () async {
              try {
                final AddressEntity? addressRes = address;
                if (addressRes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'no_default_address_found'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.teal,
                      elevation: 6,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: 'add_address'.tr(),
                        textColor: Colors.white,
                        onPressed: () {
                          _selectAddress(context, cartPro);
                        },
                      ),
                    ),
                  );
                  return;
                }

                final OfferPaymentParams params = OfferPaymentParams(
                  offerId: offerId,
                  buyerAddress: AddressModel.fromEntity(addressRes),
                );

                final DataState<String> result =
                    await OfferPaymentUsecase(locator()).call(params);
                debugPrint('💬 Offer ID for payment: $offerId');
                final String? clientSecret = result.entity;

                if (clientSecret == null || clientSecret.isEmpty) {
                  throw CustomException('client_secret_missing'.tr());
                }

                await Stripe.instance.initPaymentSheet(
                  paymentSheetParameters: SetupPaymentSheetParameters(
                    paymentIntentClientSecret: clientSecret,
                    style: ThemeMode.system,
                    merchantDisplayName: 'sellout',
                  ),
                );

                await Stripe.instance.presentPaymentSheet();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('payment_successful'.tr())),
                );
              } catch (e) {
                debugPrint('❌ Payment error: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('${'payment_failed'.tr()}: ${e.toString()}')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
