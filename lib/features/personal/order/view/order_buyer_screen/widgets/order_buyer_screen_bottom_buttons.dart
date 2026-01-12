import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../services/get_it.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../data/models/return_eligibility_model.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/params/return_eligibility_params.dart';
import '../../../domain/usecase/check_return_eligibility_usecase.dart';
import 'cancel_order_button.dart';
import 'request_return_bottom_sheet.dart';

class OrderBuyerScreenBottomButtons extends StatefulWidget {
  const OrderBuyerScreenBottomButtons({
    required this.order,
    this.post,
    super.key,
  });

  final OrderEntity order;
  final PostEntity? post;

  @override
  State<OrderBuyerScreenBottomButtons> createState() =>
      _OrderBuyerScreenBottomButtonsState();
}

class _OrderBuyerScreenBottomButtonsState
    extends State<OrderBuyerScreenBottomButtons> {
  bool _isEligibleForReturn = false;
  bool _isCheckingEligibility = false;

  bool get _canShowReturnButton =>
      widget.order.orderStatus == StatusType.completed ||
      widget.order.orderStatus == StatusType.delivered;

  bool get _hasActions =>
      (_canShowReturnButton && _isEligibleForReturn) ||
      widget.order.orderStatus == StatusType.pending;

  @override
  void initState() {
    super.initState();
    if (_canShowReturnButton) {
      _checkReturnEligibility();
    }
  }

  Future<void> _checkReturnEligibility() async {
    if (widget.post == null) return;

    setState(() => _isCheckingEligibility = true);

    try {
      final DataState<ReturnEligibilityModel> result =
          await CheckReturnEligibilityUsecase(locator()).call(
            ReturnEligibilityParams(
              orderId: widget.order.orderId,
              objectId:
                  widget.order.shippingDetails?.postage.first.rateObjectId ??
                  '',
            ),
          );

      if (result is DataSuccess<ReturnEligibilityModel> &&
          result.entity != null) {
        setState(() {
          _isEligibleForReturn =
              result.entity!.allowed == true &&
              result.entity!.returnAlreadyRequested != true;
        });
      }
    } catch (e) {
      // If check fails, don't show the button
      setState(() => _isEligibleForReturn = false);
    } finally {
      setState(() => _isCheckingEligibility = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingEligibility) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (!_hasActions) {
      return const SizedBox.shrink();
    }

    return Row(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'more_actions'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_canShowReturnButton && _isEligibleForReturn)
              CustomElevatedButton(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                isLoading: false,
                onTap: () async {
                  await showRequestReturnBottomSheet(
                    context: context,
                    order: widget.order,
                    post: widget.post,
                  );
                },
                title: 'request_return'.tr(),
                bgColor: Colors.transparent,
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
            if (widget.order.orderStatus == StatusType.pending)
              CancelOrderButton(order: widget.order),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
