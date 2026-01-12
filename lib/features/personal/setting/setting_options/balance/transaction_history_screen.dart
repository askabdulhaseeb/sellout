import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../payment/domain/entities/wallet_transaction_entity.dart';
import 'widgets/transaction_item_card.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({
    required this.transactionHistory,
    super.key,
  });

  final List<WalletTransactionEntity> transactionHistory;

  static String routeName = '/transaction-history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('transaction_history'.tr())),
      body: transactionHistory.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_transaction_history'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactionHistory.length,
              itemBuilder: (BuildContext context, int index) {
                final WalletTransactionEntity transaction =
                    transactionHistory[index];

                return TransactionItemCard(transaction: transaction);
              },
            ),
    );
  }
}
