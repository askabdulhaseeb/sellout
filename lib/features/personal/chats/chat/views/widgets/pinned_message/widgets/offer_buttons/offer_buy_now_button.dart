import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../auth/signin/data/models/address_model.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../../../post/domain/entities/offer/offer_payment_response.dart';
import '../../../../../../../post/domain/params/offer_payment_params.dart';
import '../../../../../../../post/domain/usecase/offer_payment_usecase.dart';

class OfferBuyNowButton extends StatefulWidget {
  const OfferBuyNowButton({
    required this.offerId,
    required this.postId,
    super.key,
  });
  final String offerId;
  final String postId;

  @override
  State<OfferBuyNowButton> createState() => _OfferBuyNowButtonState();
}

class _OfferBuyNowButtonState extends State<OfferBuyNowButton> {
  bool _isLoading = false;

  AddressEntity? get _defaultAddress {
    final List<AddressEntity>? userAddresses = LocalAuth.currentUser?.address;
    if (userAddresses != null &&
        userAddresses.where((AddressEntity e) => e.isDefault).isNotEmpty) {
      return userAddresses.firstWhere((AddressEntity e) => e.isDefault);
    }
    if (userAddresses != null && userAddresses.isNotEmpty) {
      return userAddresses.first;
    }
    return null;
  }

  Future<void> _onTap() async {
    if (_isLoading) return;

    final AddressEntity? address = _defaultAddress;
    if (address == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('no_default_address_found'.tr())));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Shipping is already added, proceed directly to payment
      AppLog.info(
        'Creating payment intent for offer: ${widget.offerId}',
        name: 'OfferBuyNowButton',
      );

      final OfferPaymentParams params = OfferPaymentParams(
        offerId: widget.offerId,
        buyerAddress: AddressModel.fromEntity(address),
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

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('payment_successful'.tr())));
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
