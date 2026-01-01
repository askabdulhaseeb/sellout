import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../payment/domain/entities/wallet_entity.dart';
import '../balance_skeleton.dart';
import '../provider/wallet_provider.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/funds_in_hold_section.dart';
import '../widgets/transaction_history_section.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  static String routeName = '/wallet';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WalletProvider>(
      create: (_) {
        final WalletProvider provider = WalletProvider()
          ..initFromCache()
          ..fetchWallet();
        return provider;
      },
      child: const _WalletScreenContent(),
    );
  }
}

class _WalletScreenContent extends StatelessWidget {
  const _WalletScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('wallet'.tr())),
      body: Consumer<WalletProvider>(
        builder:
            (BuildContext context, WalletProvider provider, Widget? child) {
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

              final WalletEntity? wallet = provider.wallet;
              if (wallet == null) {
                return const BalanceSkeleton();
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    BalanceSummaryCard(),
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
