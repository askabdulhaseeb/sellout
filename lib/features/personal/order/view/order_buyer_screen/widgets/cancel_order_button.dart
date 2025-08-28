import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../services/get_it.dart';
import '../../../../user/profiles/domain/params/update_order_params.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/usecase/update_order_usecase.dart';

class CancelOrderButton extends StatefulWidget {
  const CancelOrderButton({
    required this.order, super.key,
  });

  final OrderEntity order;

  @override
  State<CancelOrderButton> createState() => _CancelOrderButtonState();
}

class _CancelOrderButtonState extends State<CancelOrderButton> {
  bool _isLoading = false;

  Future<void> _cancelOrder() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final UpdateOrderUsecase orderUsecase = UpdateOrderUsecase(locator());
      final DataState<bool> result = await orderUsecase.call(
        UpdateOrderParams(
          orderId: widget.order.orderId,
          status: StatusType.cancelled,
        ),
      );

      if (!mounted) return;

      if (result is DataSuccess<bool> && result.data == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('order_cancelled_success'.tr()),
            backgroundColor: Colors.green,
          ),
        );
      } else if (result is DataFailer<bool>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'order_cancel_failed'
                  .tr(args: [result.exception?.message ?? 'Unknown error']),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('order_cancel_failed'.tr(args: ['Unexpected response'])),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('order_cancel_failed'.tr(args: [e.toString()])),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      isLoading: _isLoading,
      title: 'cancel_this_order'.tr(),
      onTap: _cancelOrder,
      bgColor: Colors.transparent,
      textStyle: const TextStyle(color: AppTheme.primaryColor),
    );
  }
}
