import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../payment/data/models/wallet_model.dart';
import 'balance_detail_row.dart';
import 'balance_formatters.dart';

class WalletDetailsCard extends StatelessWidget {
  const WalletDetailsCard({required this.wallet, super.key});

  final WalletModel wallet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'wallet_details'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BalanceDetailRow(labelKey: 'wallet_id', value: wallet.walletId),
              BalanceDetailRow(labelKey: 'entity_id', value: wallet.entityId),
              BalanceDetailRow(labelKey: 'status', value: wallet.status),
              BalanceDetailRow(
                labelKey: 'created_at',
                value: BalanceFormatters.formatDateTime(wallet.createdAt),
              ),
              BalanceDetailRow(
                labelKey: 'next_release_at',
                value: wallet.nextReleaseAt,
              ),
              BalanceDetailRow(
                labelKey: 'total_refunded',
                value: BalanceFormatters.formatAmount(
                  wallet.totalRefunded,
                  currencyCode: wallet.currency,
                ),
              ),
              BalanceDetailRow(
                labelKey: 'transaction_history_count',
                value: wallet.transactionHistory.length.toString(),
              ),
              BalanceDetailRow(
                labelKey: 'funds_in_hold_count',
                value: wallet.fundsInHold.length.toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
