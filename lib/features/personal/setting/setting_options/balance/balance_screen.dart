import 'package:flutter/material.dart';

import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';
import '../../../payment/data/models/wallet_model.dart';
import 'package:intl/intl.dart';
import '../../../../../core/sources/data_state.dart';
import 'balance_skeleton.dart';
import 'package:easy_localization/easy_localization.dart';

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
        _wallet = result.entity as WalletModel;
        _loading = false;
      });
    } else {
      setState(() {
        _error = result.exception?.message ?? 'something_wrong'.tr();
        _loading = false;
      });
    }
  }

  String _formatAmount(num? amount) {
    final NumberFormat formatter = NumberFormat.currency(
      symbol: '£',
      decimalDigits: 2,
    );
    return formatter.format(amount ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('balance'.tr())),
      body: _loading || _error != null || _wallet == null
          ? const BalanceSkeleton()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatAmount(_wallet!.withdrawableBalance),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'approx_pkr'.tr(args: ['0.00']),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
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
                              'currency'.tr(args: [_wallet!.currency]),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              'updated_at'.tr(
                                args: [
                                  DateFormat.Hm().format(
                                    DateTime.tryParse(_wallet!.updatedAt) ??
                                        DateTime.now(),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _balanceTile(
                              'pending'.tr(),
                              _wallet!.pendingBalance,
                            ),
                            _balanceTile(
                              'total_balance'.tr(),
                              _wallet!.totalBalance,
                            ),
                            _balanceTile(
                              'total_earned'.tr(),
                              _wallet!.totalEarnings,
                            ),
                            _balanceTile(
                              'withdrawn'.tr(),
                              _wallet!.totalWithdrawn,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'balance_note'.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _balanceTile(String label, num value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              _formatAmount(value),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
