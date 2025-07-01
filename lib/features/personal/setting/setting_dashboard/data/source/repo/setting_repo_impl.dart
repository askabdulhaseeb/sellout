// setting_repository_impl.dart

import '../../../../../../../core/sources/data_state.dart';
import '../../../domain/repo/setting_repo.dart';
import '../../../view/params/change_password_params.dart';
import '../remote/setting_api.dart';

class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl(this.api);
  final SettingRemoteApi api;

  @override
  Future<DataState<bool>> changePassword(ChangePasswordParams params) {
    return api.changePassword(params: params);
  }
}
