import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/socket_service.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../domain/params/login_params.dart';
import '../../domain/usecase/login_usecase.dart';

class SigninProvider extends ChangeNotifier {
  SigninProvider(
    this.loginUsecase,
  );

  final LoginUsecase loginUsecase;

  //
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController(
    text: kDebugMode ? 'ahmershurahbeeljan@gmail.com' : '',
  );
  //'hammadafzaal06@gmail.com'
  final TextEditingController password = TextEditingController(
    text: kDebugMode ? 'Shurahbeel_69' : '',
  );
//'Hammad@786'
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading = true;
    try {
      final DataState<bool> result = await loginUsecase(
        LoginParams(
          email: email.text,
          password: password.text,
        ),
      );
      if (result is DataSuccess<bool>) {
        debugPrint('Signin Ready');
        final SocketService socketService = SocketService();
        socketService.connect();
        isLoading = false;
        await AppNavigator.pushNamedAndRemoveUntil(
          DashboardScreen.routeName,
          (_) => false,
        );
      } else {
        debugPrint('Signin Error in Provider');
        AppLog.error(
          'Signin Error in Provider',
          name: 'SigninProvider.signIn - Else',
          error: result,
        );
        // Show error message
      }
    } catch (e) {
      debugPrint(e.toString());
      AppLog.error(e.toString(),
          name: 'SigninProvider.signIn - Catch', error: e);
    }
    isLoading = false;
  }
}
