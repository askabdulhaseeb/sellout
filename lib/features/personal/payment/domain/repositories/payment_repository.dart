import '../../../../../core/sources/data_state.dart';
import '../../data/models/wallet_model.dart';
import '../entities/exchange_rate_entity.dart';
import '../params/get_exchange_rate_params.dart';

abstract interface class PaymentRepository {
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
    GetExchangeRateParams params,
  );
  Future<DataState<WalletModel>> getWallet(String id);
}
