import '../../../../../core/sources/data_state.dart';
import '../../data/models/wallet_model.dart';
import '../entities/exchange_rate_entity.dart';
import '../params/create_payout_params.dart';
import '../params/get_exchange_rate_params.dart';
import '../params/transfer_funds_params.dart';

abstract interface class PaymentRepository {
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
    GetExchangeRateParams params,
  );
  Future<DataState<WalletModel>> getWallet(String id);
  Future<DataState<bool>> transferFunds(TransferFundsParams params);
  Future<DataState<WalletModel>> createPayouts(CreatePayoutParams params);
}
