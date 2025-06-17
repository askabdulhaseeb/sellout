import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../../../user/profiles/views/params/update_user_params.dart';

class SettingSecurityProvider extends ChangeNotifier {
  SettingSecurityProvider(this._updateProfileDetailUsecase);
  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;
  bool isLoading = false;
  bool twoFactorAuth = false;
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();

  Future<void> updateProfileDetail(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final UpdateUserParams params = UpdateUserParams(
      uid: LocalAuth.uid ?? '',
      twoFactorAuth: twoFactorAuth,
    );

    final DataState<String> result = await _updateProfileDetailUsecase(params);
    isLoading = false;
    notifyListeners();

    if (result is DataSuccess) {
      AppLog.info('profile_updated_successfully'.tr());
      Navigator.pop(context);
    } else {
      AppLog.error(result.exception!.message,
          name: 'SettingSecurityProvider.updateProfileDetail - else');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
    }
  }

  void toggleTwoFactorAuth(BuildContext context, bool value) {
    twoFactorAuth = value;
    notifyListeners();
    updateProfileDetail(context);
  }
}
