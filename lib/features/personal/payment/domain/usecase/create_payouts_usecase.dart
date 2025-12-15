import '../../../../../core/usecase/usecase.dart';
import '../../data/models/wallet_model.dart';
import '../entities/wallet_entity.dart';
import '../params/create_payout_params.dart';
import '../repositories/payment_repository.dart';

class CreatePayoutsUsecase
    implements UseCase<WalletEntity, CreatePayoutParams> {
  const CreatePayoutsUsecase(this.repository);

  final PaymentRepository repository;

  @override
  Future<DataState<WalletModel>> call(CreatePayoutParams params) async {
    return await repository.createPayouts(params);
  }
}
