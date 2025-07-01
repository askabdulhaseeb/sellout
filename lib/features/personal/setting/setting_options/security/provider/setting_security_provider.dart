import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../user/profiles/views/params/update_user_params.dart';
import '../../../setting_dashboard/domain/usecase/change_password_usecase.dart';
import '../../../setting_dashboard/view/params/change_password_params.dart';

class SettingSecurityProvider extends ChangeNotifier {
  SettingSecurityProvider(
    this._updateProfileDetailUsecase,
    this._changePasswordUseCase,
  );

  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;
  final ChangePasswordUseCase _changePasswordUseCase;

  bool isLoading = false;
  bool twoFactorAuth = false;

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> updateProfileDetail(BuildContext context) async {
    setLoading(true);

    final UpdateUserParams params = UpdateUserParams(
      uid: LocalAuth.uid ?? '',
      twoFactorAuth: twoFactorAuth,
    );

    final DataState<String> result = await _updateProfileDetailUsecase(params);
    setLoading(false);

    if (result is DataSuccess) {
      AppLog.info('profile_updated_successfully'.tr());
      Navigator.pop(context);
    } else {
      AppLog.error(result.exception?.message ?? 'something_wrong',
          name: 'SettingSecurityProvider.updateProfileDetail - error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
    }
  }

  Future<void> changePassword(
    BuildContext context, {
    required String oldPassword,
    required String newPassword,
  }) async {
    setLoading(true);
    final ChangePasswordParams params = ChangePasswordParams(
      oldPassword: oldPassword,
      password: newPassword,
    );
    final DataState<bool> result = await _changePasswordUseCase(params);
    setLoading(false);
    if (result is DataSuccess) {
      AppLog.info('password_changed_successfully'.tr());
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      AppLog.error(result.exception?.reason ?? 'something_wrong',
          name: 'SettingSecurityProvider.changePassword - error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result.exception?.reason ?? 'something_wrong'.tr())),
      );
    }
  }

  void toggleTwoFactorAuth(BuildContext context, bool value) {
    twoFactorAuth = value;
    notifyListeners();
    updateProfileDetail(context);
  }
}
