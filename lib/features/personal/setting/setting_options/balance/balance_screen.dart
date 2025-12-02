import 'package:flutter/material.dart';

import '../../../../../services/get_it.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../payment/domain/usecase/get_wallet_usecase.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});
  static String routeName = '/balance';

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  void initState() {
    super.initState();
    GetWalletUsecase(
      locator(),
    ).call(LocalAuth.currentUser?.stripeConnectAccount?.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar());
  }
}
