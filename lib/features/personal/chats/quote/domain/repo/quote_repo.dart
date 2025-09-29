import '../../../../../../core/sources/api_call.dart';
import '../params/hold_quote_pay_params.dart';
import '../params/request_quote_service_params.dart';
import '../params/update_quote_params.dart';

abstract class QuoteRepo {
  Future<DataState<bool>> requestQuote(RequestQuoteParams params);
  Future<DataState<bool>> updateQuote(UpdateQuoteParams params);
  Future<DataState<bool>> createQuote(bool params);
  Future<DataState<bool>> holdQuotePayment(HoldQuotePayParams params);
}
