import '../../../../../../core/sources/data_state.dart';
export '../../../../../../core/sources/data_state.dart';

abstract interface class SigninRepository {
  Future<DataState<bool>> signin(String email, String password);
}
