import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../payment/domain/entities/wallet_transaction_entity.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({
    required this.transactionHistory,
    super.key,
  });

  final List<WalletTransactionEntity> transactionHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'transaction_history'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (transactionHistory.isEmpty)
          Text('no_transaction_history'.tr())
        else
          Column(
            children: transactionHistory
                .map(
                  (WalletTransactionEntity tx) => Container(
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
                    child: Text(
                      const JsonEncoder.withIndent('  ').convert(tx.raw),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
