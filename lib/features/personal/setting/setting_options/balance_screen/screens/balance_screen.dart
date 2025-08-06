import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../services/get_it.dart';
import '../providers/balance_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/create_account_prompt.dart';
import '../widgets/stripe_setup_loader.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});
  static String routeName = 'personal_settig_balance';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BalanceProvider>(
      create: (_) => BalanceProvider(locator()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Balance'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: BalanceScreenBody(),
        ),
      ),
    );
  }
}

class BalanceScreenBody extends StatelessWidget {
  const BalanceScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BalanceProvider>(context);

    if (provider.isSettingUpStripe) {
      // 👇 Show loader while onboarding link is being fetched
      return const StripeSetupLoader();
    }

    if (provider.hasStripeAccount) {
      // 👇 If connected, show balance card
      return const BalanceCard();
    } else {
      // 👇 If not connected, prompt user to set up Stripe
      return const CreateAccountPrompt();
    }
  }
}
