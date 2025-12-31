import '../../domain/repositories/wallet_repository.dart';
import '../models/wallet_model.dart';
import '../sources/remote/wallet_remote_api.dart';
import '../../domain/params/transfer_funds_params.dart';
import '../../domain/params/create_payout_params.dart';
import '../../../../../../core/sources/data_state.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this.remoteApi);
  final WalletRemoteApi remoteApi;

  @override
  Future<DataState<WalletModel>> getWallet(String id) async {
    return await remoteApi.getWallet(id);
  }

  @override
  Future<DataState<bool>> transferFunds(TransferFundsParams params) async {
    return await remoteApi.transferFunds(params);
  }

  @override
  Future<DataState<bool>> createPayouts(CreatePayoutParams params) async {
    return await remoteApi.createPayouts(params);
  }
}
