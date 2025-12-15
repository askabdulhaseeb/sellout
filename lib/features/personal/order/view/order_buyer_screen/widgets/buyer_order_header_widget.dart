import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import 'two_style_text.dart';

class BuyerOrderHeaderWidget extends StatelessWidget {
  const BuyerOrderHeaderWidget({required this.orderData, super.key});

  final OrderEntity orderData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TwoStyleText(
          firstText: 'time_placed'.tr(),
          secondText: DateFormat(
            'd MMM yyyy \'at\' h:mm a',
          ).format(orderData.updatedAt),
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
