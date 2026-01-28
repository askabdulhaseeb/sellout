import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/bottom_sheets/address/address_bottom_sheet.dart';
import '../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../basket/data/models/cart/buynow_add_shipping_response_model.dart';
import '../../../../../../../../postage/data/models/postage_detail_response_model.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../../../../post/domain/params/buy_now_shipping_rates_params.dart';
import '../../../../../../../post/domain/usecase/get_buy_now_shipping_rates_usecase.dart';
import 'offer_shipping_rates_bottom_sheet.dart';

class OfferGetShippingButton extends StatefulWidget {
  const OfferGetShippingButton({
    required this.offerId,
    required this.postId,
    required this.onShippingAdded,
    super.key,
  });

  final String offerId;
  final String postId;
  final VoidCallback onShippingAdded;

  @override
  State<OfferGetShippingButton> createState() => _OfferGetShippingButtonState();
}

class _OfferGetShippingButtonState extends State<OfferGetShippingButton> {
  bool _isLoading = false;
  AddressEntity? _selectedAddress;

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

    // 1) Select shipping address
    final AddressEntity? address = await _selectAddress();

    if (address == null) {
      AppLog.info(
        'User cancelled address selection',
        name: 'OfferGetShippingButton',
      );
      return;
    }

    _selectedAddress = address;

    setState(() => _isLoading = true);

    try {
      // 2) Fetch shipping rates for this offer
      AppLog.info(
        'Fetching shipping rates for post: ${widget.postId}, offer: ${widget.offerId}',
        name: 'OfferGetShippingButton',
      );

      final DataState<PostageDetailResponseModel> ratesState =
          await GetBuyNowShippingRatesUsecase(locator()).call(
            BuyNowShippingRatesParams(
              postId: widget.postId,
              buyerAddress: address,
              isOffer: true,
              offerId: widget.offerId,
            ),
          );

      if (!mounted) return;

      if (ratesState is! DataSuccess<PostageDetailResponseModel> ||
          ratesState.entity == null ||
          ratesState.entity!.detail.isEmpty) {
        AppLog.error(
          ratesState.exception?.reason ?? 'No shipping rates returned',
          name: 'OfferGetShippingButton',
          error: ratesState.exception,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_get_shipping_rates'.tr())),
        );
        return;
      }

      // 3) Show rates bottom sheet
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

      if (shippingResponse != null) {
        widget.onShippingAdded();
      }
    } catch (e) {
      AppLog.error(e.toString(), name: 'OfferGetShippingButton', error: e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('something_wrong'.tr())));
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
        title: 'get_shipping'.tr(),
        isLoading: _isLoading,
        onTap: _onTap,
      ),
    );
  }
}
