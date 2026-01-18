
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../../postage/data/models/postage_detail_repsonse_model.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../../../basket/data/models/cart/buynow_add_shipping_response_model.dart';
import '../../../../../../../post/domain/entities/offer/offer_payment_response.dart';
import '../../../../../../../post/domain/params/buy_now_shipping_rates_params.dart';
import '../../../../../../../post/domain/params/offer_payment_params.dart';
import '../../../../../../../post/domain/usecase/get_buy_now_shipping_rates_usecase.dart';
import '../../../../../../../post/domain/usecase/offer_payment_usecase.dart';
import '../../../../../../chat_dashboard/data/sources/local/local_chat.dart';
import '../../../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import 'offer_shipping_rates_bottom_sheet.dart';
import 'payment_success_bottom_sheet.dart';

class OfferBuyNowButton extends StatefulWidget {
  const OfferBuyNowButton({
    required this.postId,
    this.message,
    this.isOffer = true,
    super.key,
  });
  final MessageEntity? message;
  final String postId;
  final bool isOffer;

  @override
  State<OfferBuyNowButton> createState() => _OfferBuyNowButtonState();
}

class _OfferBuyNowButtonState extends State<OfferBuyNowButton> {
  bool _isLoading = false;
  AddressEntity? _selectedAddress;

  bool get _isOfferFlow =>
      widget.isOffer &&
      (widget.message?.offerDetail?.offerId.isNotEmpty ?? false);

  List<AddressEntity> get _userAddresses =>
      LocalAuth.currentUser?.address ?? <AddressEntity>[];

  AddressEntity? get _defaultAddress {
    if (_userAddresses.isEmpty) return null;
    final Iterable<AddressEntity> defaults = _userAddresses.where(
      (AddressEntity e) => e.isDefault,
    );
    if (defaults.isNotEmpty) return defaults.first;
    return _userAddresses.first;
  }

  Future<AddressEntity?> _selectAddress() async {
    return showModalBottomSheet<AddressEntity?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          AddressBottomSheet(initAddress: _selectedAddress ?? _defaultAddress),
    );
  }

  Future<void> _onTap() async {
    if (_isLoading) return;

    // Step 1: choose address
    final AddressEntity? address = await _selectAddress();
    if (address == null) {
      AppLog.info(
        'User cancelled address selection',
        name: 'OfferBuyNowButton',
      );
      return;
    }

    _selectedAddress = address;
    setState(() => _isLoading = true);

    try {
      // Step 2: fetch shipping rates for offer
      AppLog.info(
        'Fetching shipping rates for post: ${widget.postId}, offer: ${widget.message?.offerDetail?.offerId}',
        name: 'OfferBuyNowButton',
      );

      final DataState<PostageDetailResponseModel> ratesState =
          await GetBuyNowShippingRatesUsecase(locator()).call(
            BuyNowShippingRatesParams(
              postId: widget.postId,
              buyerAddress: address,
              isOffer: _isOfferFlow,
              offerId: _isOfferFlow
                  ? widget.message?.offerDetail?.offerId
                  : null,
            ),
          );

      if (ratesState is! DataSuccess<PostageDetailResponseModel> ||
          ratesState.entity == null ||
          ratesState.entity!.detail.isEmpty) {
        AppLog.error(
          ratesState.exception?.reason ?? 'No shipping rates returned',
          name: 'OfferBuyNowButton',
          error: ratesState.exception,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('failed_to_get_shipping_rates'.tr())),
          );
        }
        return;
      }

      // Step 3: let user pick shipping and add it
      final BuyNowAddShippingResponseModel? shippingResponse =
          await showModalBottomSheet<BuyNowAddShippingResponseModel?>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => OfferShippingRatesBottomSheet(
              response: ratesState.entity!,
              postId: widget.postId,
            ),
          );

      if (shippingResponse == null) {
        AppLog.info(
          'User cancelled shipping selection',
          name: 'OfferBuyNowButton',
        );
        return;
      }

      AppLog.info(
        'Add shipping raw response: ${jsonEncode(shippingResponse.toJson())}',
        name: 'OfferBuyNowButton',
      );

      // Step 4: create payment intent and show payment sheet
      AppLog.info(
        'Creating payment intent for ${_isOfferFlow ? 'offer' : 'post'}: ${widget.message?.offerDetail?.offerId ?? widget.postId}',
        name: 'OfferBuyNowButton',
      );

      final OfferPaymentParams params = OfferPaymentParams(
        postId: widget.postId,
        isOffer: _isOfferFlow,
        offerId: _isOfferFlow ? widget.message?.offerDetail?.offerId : null,
        ratesKey: shippingResponse.ratesKey,
        chatId: widget.message?.chatId,
        messageId: widget.message?.messageId,
      );

      final DataState<OfferPaymentResponse> result = await OfferPaymentUsecase(
        locator(),
      ).call(params);

      if (!mounted) return;

      if (result is! DataSuccess<OfferPaymentResponse> ||
          result.entity == null) {
        AppLog.error(
          result.exception?.reason ?? 'Failed to create payment intent',
          name: 'OfferBuyNowButton',
          error: result.exception,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('payment_failed'.tr())));
        return;
      }

      final String? clientSecret = result.entity?.clientSecret;

      if (clientSecret == null || clientSecret.isEmpty) {
        AppLog.error(
          'Client secret missing after payment intent',
          name: 'OfferBuyNowButton',
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('payment_failed'.tr())));
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.system,
          merchantDisplayName: 'sellout',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Clear pinned message after successful payment
      if (widget.message?.chatId != null) {
        await LocalChat().clearPinnedMessage(widget.message!.chatId);
      }

      if (mounted) {
        // Show success bottom sheet with animation
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => const PaymentSuccessBottomSheet(),
        );
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'OfferBuyNowButton', error: e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('payment_failed'.tr())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        borderRadius: BorderRadius.circular(6),
        title: 'buy_now'.tr(),
        isLoading: _isLoading,
        onTap: _onTap,
      ),
    );
  }
}
