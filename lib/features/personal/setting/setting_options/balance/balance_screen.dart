import 'package:flutter/material.dart';
import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../payment/domain/params/create_payout_params.dart';
import '../../../payment/domain/params/transfer_funds_params.dart';
import '../../../payment/domain/usecase/create_payouts_usecase.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../payment/domain/usecase/transfer_funds_usecase.dart';
import '../../../payment/data/models/wallet_model.dart';
import '../../../../../core/sources/data_state.dart';
import 'balance_skeleton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/balance_summary_card.dart';
import 'widgets/funds_in_hold_section.dart';
import 'widgets/transaction_history_section.dart';

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
  bool _withdrawing = false;

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

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _withdrawToBank() async {
    final WalletModel? wallet = _wallet;
    if (wallet == null) return;

    final String walletId =
        LocalAuth.currentUser?.stripeConnectAccount?.id ?? '';
    if (walletId.isEmpty) {
      _showSnack('something_wrong'.tr());
      return;
    }

    final double amount = wallet.withdrawableBalance;
    if (amount <= 0) {
      _showSnack('nothing_to_withdraw'.tr());
      return;
    }

    if (_withdrawing) return;
    setState(() => _withdrawing = true);

    try {
      final TransferFundsUsecase transferUsecase = TransferFundsUsecase(
        locator(),
      );
      final DataState<bool> transferResult = await transferUsecase.call(
        TransferFundsParams(
          walletId: walletId,
          amount: amount,
          currency: wallet.currency,
        ),
      );

      if (transferResult is! DataSuccess || transferResult.entity != true) {
        _showSnack(transferResult.exception?.message ?? 'withdraw_failed'.tr());
        return;
      }

      final CreatePayoutsUsecase payoutsUsecase = CreatePayoutsUsecase(
        locator(),
      );
      final DataState<WalletModel> payoutResult = await payoutsUsecase.call(
        CreatePayoutParams(
          walletId: walletId,
          amount: amount,
          currency: wallet.currency,
        ),
      );

      if (payoutResult is DataSuccess && payoutResult.entity != null) {
        setState(() {
          _wallet = payoutResult.entity;
        });
        _showSnack('withdraw_success'.tr());
        return;
      }

      _showSnack(payoutResult.exception?.message ?? 'withdraw_failed'.tr());
    } finally {
      if (mounted) {
        setState(() => _withdrawing = false);
      }
      await _fetchWallet();
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
                  BalanceSummaryCard(
                    wallet: wallet,
                    isWithdrawing: _withdrawing,
                    onWithdrawTap: _withdrawToBank,
                  ),
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
