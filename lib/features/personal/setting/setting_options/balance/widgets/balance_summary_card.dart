import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../payment/data/models/wallet_model.dart';
import 'balance_formatters.dart';
import 'balance_tile.dart';

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({
    required this.wallet,
    required this.onWithdrawTap,
    super.key,
  });

  final WalletModel wallet;
  final VoidCallback onWithdrawTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.red,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                'available_balance'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            BalanceFormatters.formatAmount(
              wallet.withdrawableBalance,
              currencyCode: wallet.currency,
            ),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              Text(
                'approx_pkr'.tr(args: <String>['0.00']),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'live_rates_apply'.tr(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'currency'.tr(args: <String>[wallet.currency]),
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              Text(
                'updated_at'.tr(
                  args: <String>[
                    BalanceFormatters.formatDateTime(wallet.updatedAt),
                  ],
                ),
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BalanceTile(
                label: 'pending'.tr(),
                value: wallet.pendingBalance,
                currencyCode: wallet.currency,
              ),
              BalanceTile(
                label: 'total_balance'.tr(),
                value: wallet.totalBalance,
                currencyCode: wallet.currency,
              ),
              BalanceTile(
                label: 'total_earned'.tr(),
                value: wallet.totalEarnings,
                currencyCode: wallet.currency,
              ),
              BalanceTile(
                label: 'withdrawn'.tr(),
                value: wallet.totalWithdrawn,
                currencyCode: wallet.currency,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onWithdrawTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'withdraw_to_bank_account'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'balance_note'.tr(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
