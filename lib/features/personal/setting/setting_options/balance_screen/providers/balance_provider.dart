import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../setting_dashboard/domain/params/create_account_session_params.dart';
import '../../../setting_dashboard/domain/usecase/connect_account_session_usecase.dart';

class BalanceProvider extends ChangeNotifier {
  BalanceProvider(this._connectAccountSessionUseCase);
  final ConnectAccountSessionUseCase _connectAccountSessionUseCase;

  bool hasStripeAccount = false;
  bool isSettingUpStripe = false;

  static const MethodChannel _channel =
      MethodChannel('com.sellout.sellout/stripe');

  Future<void> startStripeSetupFlow() async {
    isSettingUpStripe = true;
    notifyListeners();

    // Get the session secret from backend
    final String sessionSecret = await getSessionSecret();

    if (sessionSecret.isNotEmpty) {
      try {
        await _channel.invokeMethod('openConnectOnboarding',
            <String, String>{'sessionId': sessionSecret});
        hasStripeAccount = true; // optionally verify via backend
      } on PlatformException catch (e) {
        debugPrint('Error launching Stripe onboarding: ${e.message}');
      }
    }

    isSettingUpStripe = false;
    notifyListeners();
  }

  Future<String> getSessionSecret() async {
    try {
      final DataState<String> result = await _connectAccountSessionUseCase.call(
        ConnectAccountSessionParams(
          email: '', // For loggedin user
          country: '', // For loggedin user
          entityId: '', // For loggedin user
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
    }
    return '';
  }
}
