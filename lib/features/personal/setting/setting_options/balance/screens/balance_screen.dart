import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../payment/domain/entities/wallet_entity.dart';
import '../../../../payment/data/sources/local/local_wallet.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../balance_skeleton.dart';
import '../provider/balance_provider.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/funds_in_hold_section.dart';
import '../widgets/transaction_history_section.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});
  static String routeName = '/balance';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BalanceProvider>(
      create: (_) => BalanceProvider()..initFromCache(),
      child: const _BalanceScreenContent(),
    );
  }
}

class _BalanceScreenContent extends StatelessWidget {
  const _BalanceScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('balance'.tr())),
      body: Consumer<BalanceProvider>(
        builder:
            (BuildContext context, BalanceProvider provider, Widget? child) {
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

              final String walletId = LocalAuth.stripeAccountId ?? '';
              final WalletEntity? wallet =
                  (walletId.isNotEmpty
                      ? LocalWallet().getWallet(walletId)
                      : null) ??
                  provider.wallet;
              if (wallet == null) {
                return const BalanceSkeleton();
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    BalanceSummaryCard(
                   
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
