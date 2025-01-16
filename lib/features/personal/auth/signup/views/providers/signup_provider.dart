import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../core/functions/permission_fun.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../enums/signup_page_type.dart';
import '../screens/pages/signup_basic_info_page.dart';
import '../screens/pages/signup_dob_page.dart';
import '../screens/pages/signup_location_page.dart';
import '../screens/pages/signup_otp_verification_page.dart';
import '../screens/pages/signup_photo_verification_page.dart';

class SignupProvider extends ChangeNotifier {
  //
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController otp = TextEditingController();
  DateTime? _dob = DateTime(2000, 1, 1);
  DateTime? get dob => _dob;
  set dob(DateTime? value) {
    _dob = value;
    notifyListeners();
  }

  //
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //
  PickedAttachment? _attachment;
  PickedAttachment? get attachment => _attachment;
  set attachment(PickedAttachment? value) {
    _attachment = value;
    notifyListeners();
  }

  //
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  SignupPageType _currentPage = SignupPageType.basicInfo;
  SignupPageType get currentPage => _currentPage;
  set currentPage(SignupPageType value) {
    _currentPage = value;
    notifyListeners();
  }

  static const int _codeSendingTime = 60;
  int _resendCodeTime = _codeSendingTime;
  int get resendCodeTime => _resendCodeTime;
  set resendCodeTime(int value) {
    _resendCodeTime = value;
    notifyListeners();
  }

  // Add a tracher for 60s to resend code
  void startResendCodeTimer() {
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (resendCodeTime > 0) {
        resendCodeTime--;
        notifyListeners();
      }
    });
  }

  Future<void> resendCode(BuildContext context) async {
    try {
      //
      resendCodeTime = _codeSendingTime;
      notifyListeners();
    } catch (e) {
      AppSnackBar.showSnackBar(context, e.toString());
    }
  }

  Future<void> enableLocation(BuildContext context) async {
    try {
      //
      final bool hasLocation = await PermissionFun.hasPermissions(<Permission>[
        Permission.location,
        Permission.locationWhenInUse,
      ]);
      if (hasLocation) {
        onNext();
      }
    } catch (e) {
      AppSnackBar.showSnackBar(context, e.toString());
    }
  }

  Widget displayedPage() {
    switch (currentPage) {
      case SignupPageType.basicInfo:
        return const SignupBasicInfoPage();
      case SignupPageType.otp:
        startResendCodeTimer();
        return const SignupOtpVerificationPage();
      case SignupPageType.photoVerification:
        return const SignupPhotoVerificationPage();
      case SignupPageType.dateOfBirth:
        return const SignupDobPage();
      case SignupPageType.location:
        return const SignupLocationPage();
    }
  }

  void onNext() {
    final SignupPageType? page = _currentPage.next();
    if (page != null) {
      currentPage = page;
      notifyListeners();
    }
  }

  void onBack(BuildContext context) {
    final SignupPageType? page = _currentPage.previous();
    if (page != null) {
      currentPage = page;
      notifyListeners();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading = true;
    // try {
    //   final DataState<bool> result = await loginUsecase(
    //     LoginParams(
    //       email: email.text,
    //       password: password.text,
    //     ),
    //   );
    //   if (result is DataSuccess<bool>) {
    //     debugPrint('Signin Ready');
    //     isLoading = false;
    //     await AppNavigator.pushNamedAndRemoveUntil(
    //       DashboardScreen.routeName,
    //       (_) => false,
    //     );
    //   } else {
    //     debugPrint('Signin Error in Provider');
    //     log(
    //       'Signin Error in Provider',
    //       name: 'SigninProvider.signIn - Else',
    //     );
    //   }
    // } catch (e) {
    //   debugPrint('Signin Error in Provider');
    //   log(
    //     'Signin Error in Provider',
    //     name: 'SigninProvider.signIn - Catch',
    //     error: e,
    //   );
    // }
    isLoading = false;
  }
}
