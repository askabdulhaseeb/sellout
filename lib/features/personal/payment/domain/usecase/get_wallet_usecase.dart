import '../../../../../core/usecase/usecase.dart';
import '../../data/models/wallet_model.dart';
import '../entities/wallet_entity.dart';
import '../params/params.dart';
import '../repositories/wallet_repository.dart';

class GetWalletUsecase implements UseCase<WalletEntity, GetWalletParams> {
  const GetWalletUsecase(this.repository);

  final WalletRepository repository;

  @override
  Future<DataState<WalletModel>> call(GetWalletParams params) async {
    return await repository.getWallet(params);
  }
}
