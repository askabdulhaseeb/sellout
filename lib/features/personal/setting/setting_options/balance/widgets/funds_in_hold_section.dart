import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../payment/domain/entities/wallet_funds_in_hold_entity.dart';
import 'balance_detail_row.dart';
import 'balance_formatters.dart';

class FundsInHoldSection extends StatelessWidget {
  const FundsInHoldSection({required this.fundsInHold, super.key});

  final List<WalletFundsInHoldEntity> fundsInHold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'funds_in_hold'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (fundsInHold.isEmpty)
          Text('no_funds_in_hold'.tr())
        else
          Column(
            children: fundsInHold
                .map(
                  (WalletFundsInHoldEntity hold) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BalanceDetailRow(
                          labelKey: 'amount',
                          value: BalanceFormatters.formatAmount(
                            hold.amount,
                            currencyCode: hold.currency,
                          ),
                        ),
                        BalanceDetailRow(
                          labelKey: 'status',
                          value: hold.status,
                        ),
                        BalanceDetailRow(
                          labelKey: 'release_at',
                          value: hold.releaseAt,
                        ),
                        BalanceDetailRow(
                          labelKey: 'order_id',
                          value: hold.orderId,
                        ),
                        BalanceDetailRow(
                          labelKey: 'post_id',
                          value: hold.postId,
                        ),
                        BalanceDetailRow(
                          labelKey: 'transaction_id',
                          value: hold.transactionId,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
