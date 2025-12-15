import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/params/create_payout_params.dart';
import '../../domain/params/get_exchange_rate_params.dart';
import '../../domain/params/transfer_funds_params.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/wallet_model.dart';
import '../sources/remote/payment_remote_api.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this.remoteApi);

  final PaymentRemoteApi remoteApi;

  @override
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
    GetExchangeRateParams params,
  ) async {
    return await remoteApi.getExchangeRate(params);
  }

  @override
  Future<DataState<WalletModel>> getWallet(String id) async {
    return await remoteApi.getWallet(id);
  }

  @override
  Future<DataState<bool>> transferFunds(TransferFundsParams params) async {
    return await remoteApi.transferFunds(params);
  }

  @override
  Future<DataState<WalletModel>> createPayouts(
    CreatePayoutParams params,
  ) async {
    return await remoteApi.createPayouts(params);
  }
}
