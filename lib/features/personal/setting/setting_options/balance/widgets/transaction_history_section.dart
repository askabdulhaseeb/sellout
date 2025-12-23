import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../payment/domain/entities/wallet_transaction_entity.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../transaction_history_screen.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({
    required this.transactionHistory,
    super.key,
  });

  final List<WalletTransactionEntity> transactionHistory;

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatType(String type) {
    switch (type.toLowerCase()) {
      case 'transfer-to-connect-account':
        return 'transfer'.tr();
      case 'payout-to-bank':
        return 'payout_to_bank'.tr();
      default:
        return type.split('-').map(_capitalize).join(' ');
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'transfer-to-connect-account':
        return Icons.swap_horiz_rounded;
      case 'payout-to-bank':
        return Icons.account_balance_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  IconData _getIconForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'authorized':
      case 'pending':
        return Icons.schedule_rounded;
      case 'completed':
      case 'released':
      case 'paid':
        return Icons.check_circle_rounded;
      case 'failed':
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<WalletTransactionEntity> previewList =
        transactionHistory.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'transaction_history'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (transactionHistory.length > 3)
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => TransactionHistoryScreen(
                      transactionHistory: transactionHistory,
                    ),
                  ),
                ),
                child: Text('see_all'.tr()),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (transactionHistory.isEmpty)
          Text('no_transaction_history'.tr())
        else
          Column(
            children: previewList.map((WalletTransactionEntity tx) {
              final String title = _formatType(tx.type);
              final String symbol = CountryHelper.currencySymbolHelper(
                tx.currency,
              );
              final String amountStr = '$symbol${tx.amount.toStringAsFixed(2)}';

              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => TransactionHistoryScreen(
                      transactionHistory: transactionHistory,
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconForType(tx.type),
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _capitalize(tx.status),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+$amountStr',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
