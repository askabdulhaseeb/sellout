import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../auth/signin/data/models/address_model.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../cart/views/providers/cart_provider.dart';
import '../../../../../../../post/domain/params/offer_payment_params.dart';
import '../../../../../../../post/domain/usecase/offer_payment_usecase.dart';
import '../../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'counter_offer_bottomsheet.dart';

class OfferMessageTileButtons extends HookWidget {
  const OfferMessageTileButtons({
    required this.message,
    super.key,
  });
  final MessageEntity message;
  void showOfferBottomSheet(BuildContext context, MessageEntity message) {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CounterBottomSheet(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider pro, _) {
        final bool isBuyer = message.offerDetail?.buyerId == LocalAuth.uid;
        final bool isSeller = message.offerDetail?.sellerId == LocalAuth.uid;

        return Column(
          children: <Widget>[
            if (isSeller)
              Row(
                spacing: 4,
                children: <Widget>[
                  // Decline button
                  Expanded(
                    child: CustomElevatedButton(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      textColor: Theme.of(context).primaryColor,
                      textStyle: TextTheme.of(context).bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500),
                      bgColor: Colors.transparent,
                      title: 'decline'.tr(),
                      isLoading: false,
                      onTap: () {
                        pro.updateOffer(
                          chatId: message.chatId,
                          context: context,
                          offerStatus: OfferStatus.reject.value,
                          offerId: message.offerDetail!.offerId,
                          messageID: message.messageId,
                        );
                      },
                    ),
                  ),
                  // Counter offer button
                  Expanded(
                    child: CustomElevatedButton(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      borderRadius: BorderRadius.circular(6),
                      textStyle: TextTheme.of(context).bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500),
                      border: Border.all(color: Colors.transparent),
                      bgColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                      title: 'counter'.tr(),
                      isLoading: false,
                      onTap: () {
                        showOfferBottomSheet(context, message);
                      },
                    ),
                  ),
                  // Accept button
                  Expanded(
                    child: CustomElevatedButton(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      borderRadius: BorderRadius.circular(6),
                      title: 'accept'.tr(),
                      textStyle: TextTheme.of(context).bodySmall?.copyWith(
                          color: ColorScheme.of(context).onPrimary,
                          fontWeight: FontWeight.w500),
                      isLoading: false,
                      onTap: () {
                        pro.updateOffer(
                          chatId: message.chatId,
                          context: context,
                          offerStatus: OfferStatus.accept.name,
                          offerId: message.offerDetail!.offerId,
                          messageID: message.messageId,
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (isBuyer)
              OfferBuyNowButton(offerId: message.offerDetail?.offerId ?? '')
          ],
        );
      },
    );
  }
}

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
      cartPro.address = selectedAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
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
                    content: Text('${'payment_failed'.tr()}: ${e.toString()}')),
              );
            }
          },
        );
      },
    );
  }
}
