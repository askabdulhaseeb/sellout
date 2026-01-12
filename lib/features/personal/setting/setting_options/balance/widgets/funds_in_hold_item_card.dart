import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../payment/domain/entities/wallet_funds_in_hold_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/shadow_container.dart';

class FundsInHoldItemCard extends StatelessWidget {
  const FundsInHoldItemCard({
    required this.hold,
    required this.order,
    required this.post,
    super.key,
  });

  final WalletFundsInHoldEntity hold;
  final OrderEntity? order;
  final PostEntity? post;


  @override
  Widget build(BuildContext context) {
    final String symbol = CountryHelper.currencySymbolHelper(hold.currency);
    final String amountStr = '$symbol${hold.amount.toStringAsFixed(2)}';
    final String releaseAtStr =
        hold.releaseAt.toDateTime()?.dateTime ?? hold.releaseAt;

    return ShadowContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'hold'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Releases on $releaseAtStr',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          Text(
            amountStr,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
