import '../../../../../../../core/sources/data_state.dart';
import '../../view/params/change_password_params.dart';

abstract class SettingRepository {
  Future<DataState<bool>> changePassword(ChangePasswordParams params);
}
