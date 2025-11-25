import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/params/get_exchange_rate_params.dart';
import '../../domain/repositories/payment_repository.dart';
import '../sources/remote/payment_remote_api.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this.remoteApi);

  final PaymentRemoteApi remoteApi;

  @override
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
      GetExchangeRateParams params) async {
    return await remoteApi.getExchangeRate(params);
  }
}
