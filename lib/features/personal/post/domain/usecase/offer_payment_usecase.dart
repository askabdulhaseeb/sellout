import '../../../../../core/usecase/usecase.dart';
import '../../../chats/chat/domain/repositories/message_reposity.dart';
import '../entities/offer/offer_payment_response.dart';
import '../params/offer_payment_params.dart';

class OfferPaymentUsecase
    implements UseCase<OfferPaymentResponse, OfferPaymentParams> {
  const OfferPaymentUsecase(this.repository);
  final MessageRepository repository;

  @override
  Future<DataState<OfferPaymentResponse>> call(OfferPaymentParams post) async {
    return await repository.offerPayment(post);
  }
}
