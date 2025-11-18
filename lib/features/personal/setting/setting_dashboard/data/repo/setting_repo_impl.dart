// setting_repository_impl.dart

import '../../../../../../core/sources/data_state.dart';
import '../../domain/params/create_account_session_params.dart';
import '../../domain/repo/setting_repo.dart';
import '../../view/params/change_password_params.dart';
import '../source/remote/setting_api.dart';

class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl(this.api);
  final SettingRemoteApi api;

  @override
  Future<DataState<bool>> changePassword(ChangePasswordParams params) {
    return api.changePassword(params: params);
  }

  @override
  Future<DataState<String>> connectAccountSession(
      ConnectAccountSessionParams params) {
    return api.connectAccountSession(params);
  }

  @override
  Future<DataState<bool>> getWallet(String params) {
    return api.getWallet(params);
  }
}
