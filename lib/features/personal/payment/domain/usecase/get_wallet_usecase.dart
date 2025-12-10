import '../../../../../core/usecase/usecase.dart';
import '../../data/models/wallet_model.dart';
import '../entities/wallet_entity.dart';
import '../repositories/payment_repository.dart';

class GetWalletUsecase implements UseCase<WalletEntity, String> {
  const GetWalletUsecase(this.repository);

  final PaymentRepository repository;

  @override
  Future<DataState<WalletModel>> call(String params) async {
    return await repository.getWallet(params);
  }
}
