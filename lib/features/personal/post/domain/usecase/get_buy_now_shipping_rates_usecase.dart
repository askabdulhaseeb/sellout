import '../../../../../core/usecase/usecase.dart';
import '../../../chats/chat/domain/repositories/message_reposity.dart';
import '../params/buy_now_shipping_rates_params.dart';
import '../../../../postage/data/models/postage_detail_repsonse_model.dart';

class GetBuyNowShippingRatesUsecase
    implements UseCase<PostageDetailResponseModel, BuyNowShippingRatesParams> {
  const GetBuyNowShippingRatesUsecase(this.repository);

  final MessageRepository repository;

  @override
  Future<DataState<PostageDetailResponseModel>> call(
    BuyNowShippingRatesParams params,
  ) async {
    return repository.getBuyNowShippingRates(params);
  }
}
