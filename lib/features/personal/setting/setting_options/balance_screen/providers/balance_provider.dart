import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../setting_dashboard/domain/params/create_account_session_params.dart';
import '../../../setting_dashboard/domain/usecase/connect_account_session_usecase.dart';

class BalanceProvider extends ChangeNotifier {
  BalanceProvider(this._connectAccountSessionUseCase);
  final ConnectAccountSessionUseCase _connectAccountSessionUseCase;

  bool hasStripeAccount = false; // toggle manually for now
  bool isSettingUpStripe = false;

  // Call this to simulate or later replace with actual API call
  Future<void> startStripeSetupFlow() async {
    isSettingUpStripe = true;
    notifyListeners();
    final String sessionSecretKey = await getSessionSecret();
    await launchStripeOnboarding(sessionSecretKey);
    isSettingUpStripe = false;
    notifyListeners();
  }

  Future<String> getSessionSecret() async {
    try {
      final DataState<String> result = await _connectAccountSessionUseCase.call(
        ConnectAccountSessionParams(
          email: '', // TODO: Fill email
          country: '', // TODO: Fill country (like 'PK')
          entityId: '', // TODO: Fill entity ID
        ),
      );

      if (result is DataSuccess<String>) {
        return result.entity ?? '';
      } else if (result is DataFailer<String>) {
        AppLog.error('',
            name: 'BalanceProvider.getSessionSecret - catch',
            error: result.exception?.message);
      }
    } catch (e, stc) {
      AppLog.error('',
          name: 'BalanceProvider.getSessionSecret - catch',
          error: e,
          stackTrace: stc);
      // snackbar or handle exception
    }

    return ''; // return null if failed
  }

  Future<void> launchStripeOnboarding(String sessionSecret) async {
    final String url =
        'https://connect.stripe.com/setup/s/accs_secret__SoWvNDUKPIiZdm8cF2tIjrm68TzGlfkRKqK2FqRi5xkPz7d';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Show snackbar or fallback
    }
  }
}
