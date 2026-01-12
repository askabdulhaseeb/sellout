import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../../core/sources/api_call.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../../postage/domain/entities/postage_detail_response_entity.dart';
import '../../../../../../../basket/data/models/cart/buynow_add_shipping_response_model.dart';
import '../../../../../../../order/view/screens/order_postage_item_card.dart';
import '../../../../../../../post/domain/params/buy_now_add_shipping_param.dart';
import '../../../../../../../post/domain/usecase/add_buy_now_shipping_usecase.dart';

class OfferShippingRatesBottomSheet extends StatefulWidget {
  const OfferShippingRatesBottomSheet({
    required this.response,
    required this.postId,
    super.key,
  });

  final PostageDetailResponseEntity response;
  final String postId;

  @override
  State<OfferShippingRatesBottomSheet> createState() =>
      _OfferShippingRatesBottomSheetState();
}

class _OfferShippingRatesBottomSheetState
    extends State<OfferShippingRatesBottomSheet> {
  String? _selectedObjectId;
  bool _isAddingShipping = false;

  PostageItemDetailEntity? get _detail {
    if (widget.response.detail.isEmpty) return null;
    return widget.response.detail.first;
  }

  void _onRateSelected(RateEntity rate) {
    setState(() => _selectedObjectId = rate.objectId);
  }

  Future<void> _addShipping() async {
    if (_selectedObjectId == null || _isAddingShipping) return;

    setState(() => _isAddingShipping = true);

    try {
      AppLog.info(
        'Adding shipping: objectId=$_selectedObjectId, postId=${widget.postId}',
        name: 'OfferShippingRatesBottomSheet',
      );

      final DataState<BuyNowAddShippingResponseModel> result =
          await AddBuyNowShippingUsecase(locator()).call(
            BuyNowAddShippingParam(
              postId: widget.postId,
              objectId: _selectedObjectId!,
            ),
          );

      if (!mounted) return;

      if (result is DataSuccess<BuyNowAddShippingResponseModel>) {
        AppLog.info(
          'Shipping added successfully',
          name: 'OfferShippingRatesBottomSheet',
        );
        AppLog.info(
          'Add shipping raw response: ${jsonEncode(result.entity?.toJson())}',
          name: 'OfferShippingRatesBottomSheet',
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('shipping_added'.tr())));
        Navigator.of(context).pop(result.entity);
      } else {
        AppLog.error(
          result.exception?.reason ?? 'Failed to add shipping',
          name: 'OfferShippingRatesBottomSheet',
          error: result.exception,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('failed_to_add_shipping'.tr())));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'OfferShippingRatesBottomSheet',
        error: e,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('something_wrong'.tr())));
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingShipping = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PostageItemDetailEntity? detail = _detail;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Header
            Row(
              children: <Widget>[
                Text(
                  'select_shipping_rate'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Content
            if (detail == null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'delivery_unavailable'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              Flexible(
                child: SingleChildScrollView(
                  child: OrderPostageItemCard(
                    detail: detail,
                    selectedRateId: _selectedObjectId,
                    onRateSelected: _onRateSelected,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Add Shipping Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_selectedObjectId == null || _isAddingShipping)
                    ? null
                    : _addShipping,
                child: _isAddingShipping
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text('add_shipping'.tr()),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
