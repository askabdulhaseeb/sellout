import '../../../../../../core/sources/data_state.dart';
import '../../data/models/wallet_model.dart';
import '../params/transfer_funds_params.dart';
import '../params/create_payout_params.dart';

abstract class WalletRepository {
  Future<DataState<WalletModel>> getWallet(String id);
  Future<DataState<bool>> transferFunds(TransferFundsParams params);
  Future<DataState<bool>> createPayouts(CreatePayoutParams params);
}
