import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../../core/helper_functions/currency_symbol_helper.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../../services/get_it.dart';
import '../../../../../../auth/signin/data/models/address_model.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../cart/views/providers/cart_provider.dart';
import '../../../../../../post/domain/params/offer_payment_params.dart';
import '../../../../../../post/domain/usecase/offer_payment_usecase.dart';
import '../../../../../../post/feed/views/enums/offer_status_enum.dart';
import '../../../../../../post/feed/views/providers/feed_provider.dart';
import '../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'widgets/offer_status_button.dart';

class OfferMessageTile extends HookWidget {
  const OfferMessageTile({required this.message, super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final FeedProvider pro = Provider.of<FeedProvider>(context, listen: false);
    debugPrint(message.offerDetail?.offerId);
    final ValueNotifier<String?> offerStatus =
        useState<String?>(message.offerDetail?.offerStatus);
    useEffect(() {
      return null;
    }, <Object?>[]);
    useEffect(() {
      final String? updatedStatus = message.offerDetail?.offerStatus;
      if (offerStatus.value != updatedStatus) {
        offerStatus.value = updatedStatus;
      }

      return null;
    }, <Object?>[message.offerDetail?.offerStatus]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ShadowContainer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        CustomNetworkImage(imageURL: message.fileUrl.first.url),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.offerDetail?.postTitle ?? 'na'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.price}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            maxLines: 2,
                            '${currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.offerPrice.toString()}',
                            style: TextTheme.of(context)
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${currencySymbolHelper(message.offerDetail?.currency)} ${message.offerDetail?.price}',
                            style: TextTheme.of(context).labelSmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(message.offerDetail?.offerStatus ?? 'na'.tr()),
                    ],
                  ),
                ),
              ],
            ),
            if (message.sendBy != LocalAuth.currentUser?.userID)
              OfferStatusButtons(message: message),
            if (message.sendBy == LocalAuth.currentUser?.userID)
              Row(
                spacing: 8,
                children: <Widget>[
                  Expanded(
                    child: CustomElevatedButton(
                        bgColor: Colors.transparent,
                        border: Border.all(color: AppTheme.primaryColor),
                        textColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.all(4),
                        title: 'cancel'.tr(),
                        isLoading: pro.isLoading,
                        onTap: () => pro.updateOffer(
                              chatId: message.chatId,
                              offerStatus: 'cancel',
                              messageID: message.messageId,
                              context: context,
                              offerId: message.offerDetail?.offerId ?? '',
                            )),
                  ),
                  if (offerStatus.value == OfferStatus.accept.value &&
                      message.sendBy == LocalAuth.currentUser?.userID)
                    Expanded(
                        child: OfferBuyNowButton(
                            offerId: message.offerDetail?.offerId ?? ''))
                ],
              ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.all(4),
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
                  merchantDisplayName: 'sellout', // use your localized app name
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
