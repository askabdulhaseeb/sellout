import '../../../../../../core/usecase/usecase.dart';
import '../params/hold_quote_pay_params.dart';
import '../repo/quote_repo.dart';

class HoldQuotePayUsecase implements UseCase<bool, HoldQuotePayParams> {
  const HoldQuotePayUsecase(this.repository);
  final QuoteRepo repository;

  @override
  Future<DataState<bool>> call(HoldQuotePayParams params) async {
    return await repository.holdQuotePayment(params);
  }
}
