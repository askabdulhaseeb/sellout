import 'package:flutter/material.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../payment/data/models/wallet_model.dart';
import '../../../../../core/sources/data_state.dart';
import 'balance_skeleton.dart';
import 'package:easy_localization/easy_localization.dart';

import 'widgets/balance_summary_card.dart';
import 'widgets/funds_in_hold_section.dart';
import 'widgets/transaction_history_section.dart';
import 'widgets/wallet_details_card.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});
  static String routeName = '/balance';

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  WalletModel? _wallet;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  Future<void> _fetchWallet() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final String walletId =
        LocalAuth.currentUser?.stripeConnectAccount?.id ?? '';
    final GetWalletUsecase usecase = GetWalletUsecase(locator());
    final DataState<WalletModel> result = await usecase.call(walletId);
    if (result is DataSuccess && result.data != null) {
      setState(() {
        _wallet = result.entity;
        _loading = false;
      });
    } else {
      setState(() {
        _error = result.exception?.message ?? 'something_wrong'.tr();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final WalletModel? wallet = _wallet;

    return Scaffold(
      appBar: AppBar(title: Text('balance'.tr())),
      body: _loading
          ? const BalanceSkeleton()
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _fetchWallet,
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            )
          : wallet == null
          ? const BalanceSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  BalanceSummaryCard(wallet: wallet, onWithdrawTap: () {}),
                  const SizedBox(height: 16),
                  WalletDetailsCard(wallet: wallet),
                  const SizedBox(height: 16),
                  FundsInHoldSection(fundsInHold: wallet.fundsInHold),
                  const SizedBox(height: 16),
                  TransactionHistorySection(
                    transactionHistory: wallet.transactionHistory,
                  ),
                ],
              ),
            ),
    );
  }
}
