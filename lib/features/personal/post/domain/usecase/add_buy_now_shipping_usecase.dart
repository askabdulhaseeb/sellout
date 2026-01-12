import '../../../../../core/usecase/usecase.dart';
import '../../../basket/data/models/cart/buynow_add_shipping_response_model.dart';
import '../../../chats/chat/domain/repositories/message_reposity.dart';
import '../params/buy_now_add_shipping_param.dart';

class AddBuyNowShippingUsecase
    implements UseCase<BuyNowAddShippingResponseModel, BuyNowAddShippingParam> {
  const AddBuyNowShippingUsecase(this.repository);

  final MessageRepository repository;

  @override
  Future<DataState<BuyNowAddShippingResponseModel>> call(
    BuyNowAddShippingParam params,
  ) async {
    return repository.addBuyNowShipping(params);
  }
}
