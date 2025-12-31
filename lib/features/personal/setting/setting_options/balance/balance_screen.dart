import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'balance_provider.dart';
import 'balance_skeleton.dart';
import 'widgets/balance_summary_card.dart';
import 'widgets/funds_in_hold_section.dart';
import 'widgets/transaction_history_section.dart';
import 'widgets/transfer_to_stripe_dialog.dart';
import 'widgets/withdraw_funds_dialog.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});
  static String routeName = '/balance';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BalanceProvider>(
      create: (_) => BalanceProvider()..fetchWallet(),
      child: const _BalanceScreenContent(),
    );
  }
}

class _BalanceScreenContent extends StatelessWidget {
  const _BalanceScreenContent();

  void _showWithdrawDialog(BuildContext context, BalanceProvider provider) {
    if (provider.wallet == null) return;

    WithdrawFundsDialog.show(
      context: context,
      walletBalance: provider.walletBalance,
      stripeBalance: provider.stripeBalance,
      currency: provider.currency,
      onTransferToStripe: () => _showTransferToStripeDialog(context, provider),
      onWithdrawToBank: () => _showPayoutDialog(context, provider),
    );
  }

  void _showTransferToStripeDialog(
    BuildContext context,
    BalanceProvider provider,
  ) {
    if (provider.wallet == null) return;
    Navigator.of(context).pop();
    TransferToStripeDialog.show(
      context: context,
      mode: TransferDialogMode.walletToStripe,
    );
  }

  void _showPayoutDialog(BuildContext context, BalanceProvider provider) {
    if (provider.wallet == null) return;
    Navigator.of(context).pop();
    TransferToStripeDialog.show(
      context: context,
      mode: TransferDialogMode.stripeToBank,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('balance'.tr())),
      body: Consumer<BalanceProvider>(
        builder: (
          BuildContext context,
          BalanceProvider provider,
          Widget? child,
        ) {
          if (provider.loading) {
            return const BalanceSkeleton();
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(provider.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.fetchWallet(),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          final wallet = provider.wallet;
          if (wallet == null) {
            return const BalanceSkeleton();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                BalanceSummaryCard(
                  wallet: wallet,
                  isWithdrawing: provider.isProcessing,
                  isRefreshing: provider.refreshing,
                  onWithdrawTap: () => _showWithdrawDialog(context, provider),
                  onRefreshTap: () => provider.fetchWallet(isRefresh: true),
                ),
                const SizedBox(height: 16),
                FundsInHoldSection(fundsInHold: wallet.fundsInHold),
                const SizedBox(height: 16),
                TransactionHistorySection(
                  transactionHistory: wallet.transactionHistory,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
