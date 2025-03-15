import '../../../../../../core/usecase/usecase.dart';
import '../../view/params/verify_pin_params.dart';
import '../repository/find_account_repository.dart';

class VerifyOtpUseCase implements UseCase<bool, VerifyPinParams> {
  VerifyOtpUseCase(this.repository);
  final FindAccountRepository repository;

  @override
  Future<DataState<bool>> call(VerifyPinParams params) async {
    try {
      final DataState<bool> result = await repository.verifyOtp(params);
      return result;
    } catch (e) {
      return DataFailer<bool>(CustomException('Error: $e'));
    }
  }
}
