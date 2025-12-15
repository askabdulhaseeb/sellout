import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/in_dev_mode.dart';
import '../../../domain/entities/order_entity.dart';
import 'cancel_order_button.dart';
import 'request_return_bottom_sheet.dart';

class OrderBuyerScreenBottomButtons extends StatelessWidget {
  const OrderBuyerScreenBottomButtons({required this.order, super.key});

  final OrderEntity order;

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
                if (order.orderStatus == StatusType.completed ||
                    order.orderStatus == StatusType.delivered)
                  CustomElevatedButton(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    isLoading: false,
                    onTap: () async {
                      await showRequestReturnBottomSheet(
                        context: context,
                        order: order,
                      );
                    },
                    title: 'request_return'.tr(),
                    bgColor: Colors.transparent,
                    textStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                if (order.orderStatus == StatusType.shipped ||
                    order.orderStatus == StatusType.pending ||
                    order.orderStatus == StatusType.processing)
                  CancelOrderButton(order: order),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
