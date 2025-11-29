import '../../../../../core/usecase/usecase.dart';
import '../entities/exchange_rate_entity.dart';
import '../params/get_exchange_rate_params.dart';
import '../repositories/payment_repository.dart';

class GetExchangeRateUsecase
    implements UseCase<ExchangeRateEntity, GetExchangeRateParams> {
  const GetExchangeRateUsecase(this.repository);

  final PaymentRepository repository;

  @override
  Future<DataState<ExchangeRateEntity>> call(
      GetExchangeRateParams params) async {
    return await repository.getExchangeRate(params);
  }
}
