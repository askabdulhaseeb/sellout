import '../../../../../core/usecase/usecase.dart';
import '../../../chats/chat/domain/repositories/message_reposity.dart';
import '../params/offer_payment_params.dart';

class OfferPaymentUsecase implements UseCase<String, OfferPaymentParams> {
  const OfferPaymentUsecase(this.repository);
  final MessageRepository repository;

  @override
  Future<DataState<String>> call(OfferPaymentParams post) async {
    return await repository.offerPayment(post);
  }
}
