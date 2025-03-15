import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../repository/find_account_repository.dart';

class FindAccountUsecase implements UseCase<Map<String, dynamic>, String> {
  FindAccountUsecase(this.repository);
  final FindAccountRepository repository;

  @override
  Future<DataState<Map<String, dynamic>>> call(String params) async {
    try {
      final DataState<Map<String, dynamic>> result = await repository.findAccount(params);
      return result;
    } catch (e) {
      return DataFailer<Map<String, dynamic>>(CustomException('Error: $e'));
    }
  }
}