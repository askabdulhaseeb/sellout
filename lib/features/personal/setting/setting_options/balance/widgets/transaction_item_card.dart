import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../payment/domain/entities/wallet_transaction_entity.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/widgets/text_display/shadow_container.dart';
import 'balance_detail_row.dart';

class TransactionItemCard extends StatelessWidget {
  const TransactionItemCard({required this.transaction, super.key});

  final WalletTransactionEntity transaction;

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
      case 'release':
        return 'release'.tr();
      default:
        return type.split('-').map(_capitalize).join(' ');
    }
  }

  String _formatStatus(StatusType status) {
    // Use code for localization when available
    return status.code.tr();
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'transfer-to-connect-account':
        return Icons.swap_horiz_rounded;
      case 'payout-to-bank':
        return Icons.account_balance_rounded;
      case 'release':
        return Icons.lock_open_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  IconData _getIconForStatus(StatusType status) {
    switch (status) {
      case StatusType.pending:
      case StatusType.inprogress:
      case StatusType.processing:
      case StatusType.authorized:
        return Icons.schedule_rounded;
      case StatusType.released:
        return Icons.lock_open_rounded;
      case StatusType.accepted:
      case StatusType.completed:
      case StatusType.succeeded:
      case StatusType.delivered:
      case StatusType.shipped:
      case StatusType.active:
      case StatusType.paid:
        return Icons.check_circle_rounded;
      case StatusType.cancelled:
      case StatusType.canceled:
      case StatusType.rejected:
      case StatusType.blocked:
      case StatusType.returned:
        return Icons.cancel_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  Color _getColorForStatus(StatusType status, BuildContext context) {
    switch (status) {
      case StatusType.completed:
      case StatusType.succeeded:
      case StatusType.released:
      case StatusType.accepted:
      case StatusType.delivered:
      case StatusType.shipped:
      case StatusType.active:
      case StatusType.paid:
        return Colors.green;
      case StatusType.pending:
      case StatusType.inprogress:
      case StatusType.processing:
      case StatusType.authorized:
        return Colors.orange;
      case StatusType.cancelled:
      case StatusType.canceled:
      case StatusType.rejected:
      case StatusType.blocked:
      case StatusType.returned:
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = _formatType(transaction.type);
    final String symbol = CountryHelper.currencySymbolHelper(
      transaction.currency,
    );
    final bool isOutgoing = transaction.type.toLowerCase() == 'payout-to-bank';
    final String sign = isOutgoing ? '-' : '+';
    final String amountStr = '$sign$symbol${transaction.payoutAmount}';
    final Color amountColor = isOutgoing ? Colors.red : Colors.green;
    final String createdAtStr = _formatDate(transaction.createdAt);
    final String paidAtStr = _formatDate(transaction.paidAt);

    return ShadowContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForType(transaction.type),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(
                          _getIconForStatus(transaction.status),
                          size: 14,
                          color: _getColorForStatus(
                            transaction.status,
                            context,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatStatus(transaction.status),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _getColorForStatus(
                                  transaction.status,
                                  context,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amountStr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: amountColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          BalanceDetailRow(labelKey: 'amount', value: amountStr),
          BalanceDetailRow(
            labelKey: 'status',
            value: _formatStatus(transaction.status),
          ),
          if (createdAtStr.isNotEmpty)
            BalanceDetailRow(labelKey: 'created_at', value: createdAtStr),
          if (paidAtStr.isNotEmpty)
            BalanceDetailRow(labelKey: 'paid_at', value: paidAtStr),
          if (transaction.payoutType.isNotEmpty)
            BalanceDetailRow(
              labelKey: 'payout_type',
              value: _capitalize(transaction.payoutType),
            ),
        ],
      ),
    );
  }
}
