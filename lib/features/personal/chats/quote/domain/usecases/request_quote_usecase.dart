import '../../../../../../core/usecase/usecase.dart';
import '../params/request_quote_service_params.dart';
import '../repo/quote_repo.dart';

class RequestQuoteUsecase implements UseCase<bool, RequestQuoteParams> {
  const RequestQuoteUsecase(this.repository);
  final QuoteRepo repository;

  @override
  Future<DataState<bool>> call(RequestQuoteParams params) async {
    return await repository.requestQuote(params);
  }
}
