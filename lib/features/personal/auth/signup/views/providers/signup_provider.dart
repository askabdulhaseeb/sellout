import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../../../routes/app_linking.dart';
import '../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../dashboard/views/screens/dashboard_screen.dart';
import '../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../user/profiles/views/params/update_user_params.dart';
import '../../../signin/data/sources/local/local_auth.dart';
import '../../../signin/domain/params/login_params.dart';
import '../../../signin/domain/usecase/login_usecase.dart';
import '../../domain/usecase/register_user_usecase.dart';
import '../../domain/usecase/send_opt_usecase.dart';
import '../../domain/usecase/verify_opt_usecase.dart';
import '../../domain/usecase/verify_user_by_image_usecase.dart';
import '../enums/signup_page_type.dart';
import '../params/signup_basic_info_params.dart';
import '../params/signup_send_opt_params.dart';
import '../screens/pages/signup_basic_info_page.dart';
import '../screens/pages/signup_dob_page.dart';
import '../screens/pages/signup_location_page.dart';
import '../screens/pages/signup_otp_verification_page.dart';
import '../screens/pages/signup_photo_verification_page.dart';

class SignupProvider extends ChangeNotifier {
  SignupProvider(
    this._registerUserUsecase,
    this._sendPhoneOtpUsecase,
    this._verifyPhoneOtpUsecase,
    this._loginUsecase,
    this._updateProfileDetailUsecase,
    this._verifyUserByImageUsecase,
  );

  final RegisterUserUsecase _registerUserUsecase;
  final SendPhoneOtpUsecase _sendPhoneOtpUsecase;
  final VerifyPhoneOtpUsecase _verifyPhoneOtpUsecase;
  final LoginUsecase _loginUsecase;
  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;
  final VerifyUserByImageUsecase _verifyUserByImageUsecase;

  //
  final TextEditingController name = TextEditingController(
    text: kDebugMode ? 'ahmershurahbeeljan+test@gmail.com' : '',
  );
  final TextEditingController username = TextEditingController(
    text: kDebugMode ? 'ahmershurahbeeljan+test@gmail.com' : '',
  );
  final TextEditingController email = TextEditingController(
    text: kDebugMode ? 'ahmershurahbeeljan+test@gmail.com' : '',
  );
  final TextEditingController password = TextEditingController(
    text: kDebugMode ? 'Shurahbeel_69' : '',
  );
  final TextEditingController confirmPassword = TextEditingController(
    text: kDebugMode ? 'Shurahbeel_69' : '',
  );
  final TextEditingController phone = TextEditingController(
    text: kDebugMode ? '1234567890' : '',
  );
  final TextEditingController otp = TextEditingController();
  DateTime? _dob = DateTime(2000, 1, 1);
  DateTime? get dob => _dob;
  set dob(DateTime? value) {
    _dob = value;
    notifyListeners();
  }

  //
  //
  PickedAttachment? _attachment;
  PickedAttachment? get attachment => _attachment;
  set attachment(PickedAttachment? value) {
    _attachment = value;
    notifyListeners();
  }

  PhoneNumberEntity? _phoneNumber;
  PhoneNumberEntity? get phoneNumber => _phoneNumber;
  set phoneNumber(PhoneNumberEntity? value) {
    _phoneNumber = value;
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

  bool _accountType = true;
  bool get accountType => _accountType;
  void setAccountType(bool accountType) {
    _accountType = accountType;
    notifyListeners();
  }

  static const int _codeSendingTime = 60;
  int _resentCodeSeconds = _codeSendingTime;
  int get resentCodeSeconds => _resentCodeSeconds;
  set resentCodeSeconds(int value) {
    _resentCodeSeconds = value;
    notifyListeners();
  }

  Timer? _resendCodeTimer;
  Timer? get resendCodeTimer => _resendCodeTimer;

  Widget displayedPage() {
    switch (currentPage) {
      // case SignupPageType.accountType:
      //   return const AccountTypeScreen();
      case SignupPageType.basicInfo:
        return const SignupBasicInfoPage();
      case SignupPageType.otp:
        return const SignupOtpVerificationPage();
      case SignupPageType.dateOfBirth:
        return const SignupDobPage();
      case SignupPageType.photoVerification:
        return const SignupPhotoVerificationPage();
      case SignupPageType.location:
        return const SignupLocationPage();
    }
  }

  Future<bool> isValidBasicInfo(BuildContext context) async {
    if ((_phoneNumber?.fullNumber.length ?? 0) < 5) {
      AppSnackBar.showSnackBar(
        context,
        '${'invalid_value'.tr()}: ${'phone_number'.tr()}',
      );
      return false;
    }
    return await basicInfoPushData(context);
  }

  // ignore: always_specify_types
  void navigateToVerify(context) {
    if (_currentPage == SignupPageType.otp &&
        LocalAuth.currentUser?.otpVerified == true) {
      _currentPage = SignupPageType.dateOfBirth;
    } else if (_currentPage == SignupPageType.basicInfo &&
        LocalAuth.uid != null) {
      _currentPage = SignupPageType.otp;
    } else {}
    notifyListeners();
  }

  Future<void> onNext(BuildContext context) async {
    if (_currentPage == SignupPageType.basicInfo && LocalAuth.uid != null) {
      _moveNext(context);
    }
    if (_currentPage == SignupPageType.basicInfo) {
      if (await isValidBasicInfo(context)) {
        // ignore: use_build_context_synchronously
        _moveNext(context);
      }
    } else if (_currentPage == SignupPageType.otp) {
      if (await verifyOtp(context)) {
        // ignore: use_build_context_synchronously
        _moveNext(context);
      }
    } else if (_currentPage == SignupPageType.dateOfBirth) {
      if (await dateOfBirth(context)) {
        // ignore: use_build_context_synchronously
        _moveNext(context);
      }
    } else if (_currentPage == SignupPageType.photoVerification) {
      if (await verifyImage(context)) {
        // ignore: use_build_context_synchronously
        _moveNext(context);
      }
    } else if (_currentPage == SignupPageType.location) {
      if (await enableLocation(context)) {
        // ignore: use_build_context_synchronously
        _moveNext(context);
      }
    } else {
      _moveNext(context);
    }
  }

  _moveNext(BuildContext context) async {
    final SignupPageType? page = _currentPage.next();
    if (page != null) {
      currentPage = page;
      debugPrint('Current page before next: $_currentPage');
      debugPrint('Next page: $page');
    }
    if (_isLoading) {
      isLoading = false;
    }
    if (page == null) {
      reset();
      AppNavigator.pushNamedAndRemoveUntil(
        DashboardScreen.routeName,
        (_) => false,
      );
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

  // Add a tracher for 60s to resend code
  void startResendCodeTimer() {
    _isLoading = false;
    _resendCodeTimer?.cancel();
    _resentCodeSeconds = _codeSendingTime;
    _resendCodeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_resentCodeSeconds == 0) {
        timer.cancel();
      } else {
        _resentCodeSeconds--;
      }
      notifyListeners();
    });
  }

  Future<void> setImage(
    BuildContext context, {
    required AttachmentType type,
  }) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85, // adjust if you want to control size/quality
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        _attachment = PickedAttachment(file: file, type: AttachmentType.image);
        notifyListeners();
      } else {
        AppSnackBar.showSnackBar(context, 'No image selected');
      }
    } catch (e) {
      AppSnackBar.showSnackBar(context, 'Error picking image: $e');
    }
  }

  /// api calls
  Future<bool> basicInfoPushData(BuildContext context) async {
    isLoading = true;
    try {
      //
      final SignupBasicInfoParams params = SignupBasicInfoParams(
        name: name.text,
        username: username.text,
        email: email.text,
        phone: _phoneNumber!,
        password: password.text,
      );
      final DataState<String> result = await _registerUserUsecase(params);
      if (result is DataSuccess) {
        _loginUsecase(LoginParams(
          email: email.text,
          password: password.text,
        ));
        startResendCodeTimer();
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignupProvider.basicInfoPushData - else',
          error: result,
        );
        AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'SignupProvider.basicInfoPushData - catch',
        error: e,
      );
      // ignore: use_build_context_synchronously
      AppSnackBar.showSnackBar(context, e.toString());
    }
    isLoading = false;
    return false;
  }

  Future<bool> sendOtp(BuildContext context) async {
    if (LocalAuth.uid == null) {
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return false;
    }
    isLoading = true;
    try {
      //
      final DataState<String> result = await _sendPhoneOtpUsecase(
        SignupOptParams(uid: LocalAuth.uid ?? ''),
      );
      if (result is DataSuccess) {
        startResendCodeTimer();
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignupProvider.sendOtp - else',
          error: result,
        );
        AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'SignupProvider.sendOtp - catch',
        error: e,
      );
      // ignore: use_build_context_synchronously
      AppSnackBar.showSnackBar(context, e.toString());
    }
    isLoading = false;
    return false;
  }

  Future<bool> verifyOtp(BuildContext context) async {
    if (LocalAuth.uid == null) {
      AppLog.error(
        'uid is null',
        name: 'SignupProvider.verifyOtp - uid',
      );
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return false;
    }
    if (otp.text.isEmpty) {
      AppLog.error(
        'otp is empty',
        name: 'SignupProvider.verifyOtp - otp',
      );
      AppSnackBar.showSnackBar(context, 'otp_requirement'.tr());
      return false;
    }
    try {
      //
      final DataState<bool> result = await _verifyPhoneOtpUsecase(
        SignupOptParams(uid: LocalAuth.uid ?? '', otp: otp.text),
      );
      if (result is DataSuccess) {
        final CurrentUserEntity currentUser =
            LocalAuth.currentUser!.copyWith(otpVerified: true);
        LocalAuth().signin(currentUser);
        return true;
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'SignupProvider.verifyOtp - else',
          error: result,
        );
        AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something_wrong'.tr(),
        );
        return false;
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'SignupProvider.verifyOtp - catch',
        error: e,
      );
      // ignore: use_build_context_synchronously
      AppSnackBar.showSnackBar(context, e.toString());
    }
    return false;
  }

  Future<bool> dateOfBirth(BuildContext context) async {
    final UpdateUserParams params = UpdateUserParams(
      dob: dob,
    );
    isLoading = true;
    final DataState<String> result = await _updateProfileDetailUsecase(params);
    if (result is DataSuccess) {
      AppLog.info('profile_updated_successfully'.tr());
      isLoading = false;

      return true;
    } else {
      AppLog.error(result.exception!.message,
          name: 'SignUpProvider.dateOfBirth - else');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
      isLoading = false;
      return false;
    }
  }

  Future<bool> verifyImage(BuildContext context) async {
    if (_attachment == null) {
      AppLog.error(
        'image is null',
        name: 'SignupProvider.verifyImage - uid',
      );
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return false;
    }

    isLoading = true;
    try {
      final DataState<bool> result =
          await _verifyUserByImageUsecase(_attachment!);

      if (result is DataSuccess) {
        AppLog.info('image_verified_successfully'.tr());
        isLoading = false;
        return true;
      } else {
        AppLog.error(
          result is DataFailer
              ? result.exception?.message ?? 'Unknown error'
              : 'Verification failed',
          name: 'SignupProvider.verifyImage - failure',
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('something_wrong'.tr())),
        );
        isLoading = false;
        return false;
      }
    } catch (e, stack) {
      AppLog.error(
        'verifyImage exception: $e',
        name: 'SignupProvider.verifyImage - catch',
        error: stack,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
      isLoading = false;
      return false;
    }
  }

  Future<bool> enableLocation(BuildContext context) async {
    try {
      final PermissionStatus status =
          await Permission.locationWhenInUse.request();

      if (status == PermissionStatus.granted) {
        AppSnackBar.showSnackBar(context, 'Location permission granted.');
        return true;
      }

      if (status == PermissionStatus.permanentlyDenied) {
        AppSnackBar.showSnackBar(
          context,
          'Permission permanently denied. Please enable it from settings.',
        );
        await openAppSettings();
      } else {
        AppSnackBar.showSnackBar(context, 'Location permission denied.');
      }

      return false;
    } catch (e) {
      AppSnackBar.showSnackBar(context, 'Error: ${e.toString()}');
      return false;
    }
  }

  /// reset
  reset() {
    name.text = '';
    username.text = '';
    email.text = '';
    password.text = '';
    confirmPassword.text = '';
    phone.text = '';
    otp.text = '';
    _dob = DateTime(2000, 1, 1);
    _attachment = null;
    _phoneNumber = null;
    _isLoading = false;
    _currentPage = SignupPageType.basicInfo;
    _resendCodeTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
