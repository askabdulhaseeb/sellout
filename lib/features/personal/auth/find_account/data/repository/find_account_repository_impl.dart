import '../../../../../../core/sources/api_call.dart';
import '../../domain/repository/find_account_repository.dart';
import '../../view/params/forgot_params.dart';
import '../../view/params/new_password_params.dart';
import '../source/find_account_remote_data_source.dart';

class FindAccountRepositoryImpl implements FindAccountRepository {
  FindAccountRepositoryImpl(this.remoteDataSource);
  final FindAccountRemoteDataSource remoteDataSource;

  @override
  Future<DataState<Map<String, dynamic>>> findAccount(String email) async {
    return await remoteDataSource.findAccount(email);
  }

  @override
  Future<DataState<String>> sendEmailForOtp(OtpResponseParams params) async {
    return await remoteDataSource.sendEmailForOtp(params);
  }

  @override
  Future<DataState<String>> newPassword(NewPasswordParams params) async {
    return await remoteDataSource.newPassword(params);
  }
}
