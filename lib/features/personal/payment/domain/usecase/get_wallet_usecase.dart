import '../../../../../core/usecase/usecase.dart';
import '../repositories/payment_repository.dart';

class GetWalletUsecase implements UseCase<bool, String> {
  const GetWalletUsecase(this.repository);

  final PaymentRepository repository;

  @override
  Future<DataState<bool>> call(String params) async {
    return await repository.getWallet(params);
  }
}
