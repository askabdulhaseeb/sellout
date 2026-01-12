import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import 'two_style_text.dart';

class BuyerOrderHeaderWidget extends StatelessWidget {
  const BuyerOrderHeaderWidget({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    final StatusType rawStatus = orderData.orderStatus;
    final bool isCancelled =
        rawStatus == StatusType.cancelled || rawStatus == StatusType.canceled;

    return Column(
      children: <Widget>[
        TwoStyleText(
          firstText: 'time_placed'.tr(),
          secondText: DateFormat(
            'd MMM yyyy \'at\' h:mm a',
          ).format(orderData.updatedAt),
        ),
        if (isCancelled)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    '${'status'.tr()}:',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    'cancelled'.tr(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        TwoStyleText(
          firstText: 'order_number'.tr(),
          secondText: orderData.orderId,
        ),
        TwoStyleText(
          firstText: 'total'.tr(),
          secondText:
              '${orderData.totalAmount.toStringAsFixed(2)} (${orderData.quantity} ${'items'.tr()})',
        ),
        FutureBuilder<UserEntity?>(
          future: LocalUser().user(orderData.sellerId),
          builder: (BuildContext ctx, AsyncSnapshot<UserEntity?> snap) {
            final String sellerName =
                (snap.hasData && snap.data?.displayName.isNotEmpty == true)
                ? snap.data!.displayName
                : orderData.sellerId;
            return TwoStyleText(
              firstText: 'sold_by'.tr(),
              secondText: sellerName,
            );
          },
        ),
      ],
    );
  }
}
