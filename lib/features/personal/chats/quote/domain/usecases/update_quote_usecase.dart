import '../../../../../../core/usecase/usecase.dart';
import '../params/update_quote_params.dart';
import '../repo/quote_repo.dart';

class UpdateQuoteUsecase implements UseCase<bool, UpdateQuoteParams> {
  const UpdateQuoteUsecase(this.repository);
  final QuoteRepo repository;

  @override
  Future<DataState<bool>> call(UpdateQuoteParams params) async {
    return await repository.updateQuote(params);
  }
}
