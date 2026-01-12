import '../../../../../core/usecase/usecase.dart';
import '../params/create_payout_params.dart';
import '../repositories/wallet_repository.dart';

class CreatePayoutsUsecase
    implements UseCase<bool, CreatePayoutParams> {
  const CreatePayoutsUsecase(this.repository);

  final WalletRepository repository;

  @override
  Future<DataState<bool>> call(CreatePayoutParams params) async {
    return await repository.createPayouts(params);
  }
}
