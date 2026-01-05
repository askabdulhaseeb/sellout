import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sockets/handlers/base_socket_handler.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/stripe/data/models/stripe_connect_account_model.dart';
import '../local/local_wallet.dart';

/// Handles wallet and payment-related socket events.
class WalletSocketHandler extends BaseSocketHandler {
  @override
  List<String> get supportedEvents => <String>[
        AppStrings.walletUpdated,
        AppStrings.payoutStatusUpdated,
        AppStrings.onboardingSuccess,
      ];

  @override
  Future<void> handleEvent(String eventName, dynamic data) async {
    if (data == null) return;

    switch (eventName) {
      case 'wallet-updated':
        await _handleWalletUpdated(data);
        break;
      case 'payout-status-updated':
        await _handlePayoutStatusUpdated(data);
        break;
      case 'onboarding-success':
        await _handleOnboardingSuccess(data);
        break;
    }
  }

  Future<void> _handleWalletUpdated(dynamic data) async {
    try {
      await LocalWallet().handleWalletUpdatedEvent(data);
      AppLog.info('Wallet updated', name: 'WalletSocketHandler');
    } catch (e) {
      AppLog.error('Error handling wallet update: $e', name: 'WalletSocketHandler');
    }
  }

  Future<void> _handlePayoutStatusUpdated(dynamic data) async {
    try {
      await LocalWallet().handlePayoutStatusUpdatedEvent(data);
      AppLog.info('Payout status updated', name: 'WalletSocketHandler');
    } catch (e) {
      AppLog.error(
        'Error handling payout status: $e',
        name: 'WalletSocketHandler',
      );
    }
  }

  Future<void> _handleOnboardingSuccess(dynamic data) async {
    try {
      if (data is Map<String, dynamic>) {
        final dynamic stripeData = data['stripe_connect_account'];
        if (stripeData != null && stripeData is Map<String, dynamic>) {
          final StripeConnectAccountModel account =
              StripeConnectAccountModel.fromJson(stripeData);
          await LocalAuth.updateStripeConnectAccount(account);
          AppLog.info('Stripe onboarding success', name: 'WalletSocketHandler');
        }
      }
    } catch (e) {
      AppLog.error(
        'Error handling onboarding success: $e',
        name: 'WalletSocketHandler',
      );
    }
  }
}
