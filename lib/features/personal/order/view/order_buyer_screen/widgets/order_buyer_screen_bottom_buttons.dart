import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../../../../services/get_it.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/return_eligibility_entity.dart';
import '../../../domain/params/return_eligibility_params.dart';
import '../../../domain/usecase/check_return_eligibility_usecase.dart';
import 'cancel_order_button.dart';
import 'request_return_bottom_sheet.dart';

class OrderBuyerScreenBottomButtons extends StatefulWidget {
  const OrderBuyerScreenBottomButtons({required this.order, super.key});

  final OrderEntity order;

  @override
  State<OrderBuyerScreenBottomButtons> createState() =>
      _OrderBuyerScreenBottomButtonsState();
}

class _OrderBuyerScreenBottomButtonsState
    extends State<OrderBuyerScreenBottomButtons> {
  bool _isCheckingEligibility = false;
  bool _isEligibleForReturn = false;
  bool _hasCheckedEligibility = false;

  @override
  void initState() {
    super.initState();
    _checkReturnEligibility();
  }

  Future<void> _checkReturnEligibility() async {
    if (widget.order.orderStatus != StatusType.completed &&
        widget.order.orderStatus != StatusType.delivered) {
      return;
    }

    final String? objectId = _getObjectId();
    if (objectId == null) return;

    setState(() => _isCheckingEligibility = true);

    try {
      final DataState<ReturnEligibilityEntity> result =
          await CheckReturnEligibilityUsecase(locator()).call(
        ReturnEligibilityParams(
          orderId: widget.order.orderId,
          objectId: objectId,
        ),
      );

      if (mounted) {
        setState(() {
          _isCheckingEligibility = false;
          _hasCheckedEligibility = true;
          if (result is DataSuccess<ReturnEligibilityEntity>) {
            _isEligibleForReturn = result.entity?.allowed == true;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isCheckingEligibility = false;
          _hasCheckedEligibility = true;
          _isEligibleForReturn = false;
        });
      }
    }
  }

  String? _getObjectId() {
    if (widget.order.shippingDetails != null &&
        widget.order.shippingDetails!.postage.isNotEmpty) {
      return widget.order.shippingDetails!.postage.first.rateObjectId;
    }
    return null;
  }

  bool get _canShowReturnButton =>
      (widget.order.orderStatus == StatusType.completed ||
          widget.order.orderStatus == StatusType.delivered) &&
      _hasCheckedEligibility &&
      _isEligibleForReturn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InDevMode(
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'more_actions'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CustomElevatedButton(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0),
                  isLoading: false,
                  onTap: () {},
                  title: 'tell_us_what_you_think'.tr(),
                  bgColor: Colors.transparent,
                  textStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 8),
                if (_isCheckingEligibility)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_canShowReturnButton)
                  CustomElevatedButton(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    isLoading: false,
                    onTap: () async {
                      await showRequestReturnBottomSheet(
                        context: context,
                        order: widget.order,
                      );
                    },
                    title: 'request_return'.tr(),
                    bgColor: Colors.transparent,
                    textStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                if (widget.order.orderStatus == StatusType.shipped ||
                    widget.order.orderStatus == StatusType.pending ||
                    widget.order.orderStatus == StatusType.processing)
                  CancelOrderButton(order: widget.order),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
