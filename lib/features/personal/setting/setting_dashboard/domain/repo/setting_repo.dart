import '../../../../../../../core/sources/data_state.dart';
import '../../view/params/change_password_params.dart';
import '../params/create_account_session_params.dart';

abstract class SettingRepository {
  Future<DataState<bool>> changePassword(ChangePasswordParams params);
  Future<DataState<String>> connectAccountSession(
      ConnectAccountSessionParams params);
  Future<DataState<bool>> getWallet(String params);
}
