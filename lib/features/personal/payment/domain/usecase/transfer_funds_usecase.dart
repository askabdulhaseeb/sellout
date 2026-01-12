import '../../../../../core/usecase/usecase.dart';
import '../params/transfer_funds_params.dart';
import '../repositories/wallet_repository.dart';

class TransferFundsUsecase implements UseCase<bool, TransferFundsParams> {
  const TransferFundsUsecase(this.repository);

  final WalletRepository repository;

  @override
  Future<DataState<bool>> call(TransferFundsParams params) async {
    return await repository.transferFunds(params);
  }
}
