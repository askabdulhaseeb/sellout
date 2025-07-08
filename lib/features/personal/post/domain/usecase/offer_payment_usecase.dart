import '../../../../../core/usecase/usecase.dart';
import '../params/offer_payment_params.dart';
import '../repositories/post_repository.dart';

class OfferPaymentUsecase implements UseCase<String, OfferPaymentParams> {
  const OfferPaymentUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<String>> call(OfferPaymentParams post) async {
    return await repository.offerPayment(post);
  }
}
