import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../models/wallet_model.dart';
import '../sources/remote/wallet_remote_api.dart';
import '../sources/local/local_wallet.dart';
import '../../domain/params/transfer_funds_params.dart';
import '../../domain/params/create_payout_params.dart';
import '../../domain/params/get_wallet_params.dart';
import '../../../../../../core/sources/data_state.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this.remoteApi, this.localWallet);
  final WalletRemoteApi remoteApi;
  final LocalWallet localWallet;

  @override
  Future<DataState<WalletModel>> getWallet(GetWalletParams params) async {
    final String walletId = params.walletId;
    if (params.refresh) {
      // Always fetch from remote, update local, return
      final DataState<WalletModel> remoteResult = await remoteApi.getWallet(params);
      if (remoteResult is DataSuccess && remoteResult.data != null) {
        await localWallet.saveWallet(remoteResult.entity!);
      }
      return remoteResult;
    } else {
      // Try local first
      final WalletEntity? local = localWallet.getWallet(walletId);
      if (local != null) {
        return DataSuccess<WalletModel>('', local as WalletModel);
      } else {
        // Fallback to remote, update local, return
        final DataState<WalletModel> remoteResult = await remoteApi.getWallet(params);
        if (remoteResult is DataSuccess && remoteResult.data != null) {
          await localWallet.saveWallet(remoteResult.entity!);
        }
        return remoteResult;
      }
    }
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
