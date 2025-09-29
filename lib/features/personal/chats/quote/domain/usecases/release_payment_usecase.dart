import '../../../../../../core/usecase/usecase.dart';
import '../repo/quote_repo.dart';

class ReleaseQuotePayUsecase implements UseCase<String, String> {
  const ReleaseQuotePayUsecase(this.repository);
  final QuoteRepo repository;

  @override
  Future<DataState<String>> call(String transactionId) async {
    return await repository.releaseQuotePayment(transactionId);
  }
}
