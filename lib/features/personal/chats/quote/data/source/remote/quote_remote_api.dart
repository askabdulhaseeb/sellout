import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../domain/params/request_quote_service_params.dart';
import '../../../domain/params/update_quote_params.dart';

abstract class QuoteRemoteDataSource {
  Future<DataState<bool>> requestQuote(RequestQuoteParams params);
  Future<DataState<bool>> updateQuote(UpdateQuoteParams params);
  Future<DataState<bool>> createQuote(bool params); // buisness related api
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  @override
  Future<DataState<bool>> requestQuote(RequestQuoteParams params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/quote/request',
        requestType: ApiRequestType.post,
        body: jsonEncode(params.toMap()),
      );
      if (result is DataSuccess<bool>) {
        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(result.exception?.message ?? '',
            name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - else',
            error: 'Failed to request quote');
        return DataFailer<bool>(CustomException('Failed to request quote'));
      }
    } catch (e, stc) {
      AppLog.error('',
          name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - else',
          error: e,
          stackTrace: stc);
      return DataFailer<bool>(
          CustomException(e.toString(), detail: stc.toString()));
    }
  }

  @override
  Future<DataState<bool>> updateQuote(UpdateQuoteParams params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/quote/update',
        requestType: ApiRequestType.post,
        body: jsonEncode(params.toMap()),
      );
      if (result is DataSuccess<bool>) {
        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(result.exception?.message ?? '',
            name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - else',
            error: 'Failed to request quote');
        return DataFailer<bool>(CustomException('Failed to request quote'));
      }
    } catch (e, stc) {
      AppLog.error('',
          name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - else',
          error: e,
          stackTrace: stc);
      return DataFailer<bool>(
          CustomException(e.toString(), detail: stc.toString()));
    }
  }

  @override
  Future<DataState<bool>> createQuote(bool params) async {
    return DataFailer<bool>(CustomException('Not Implemented'));
  }
}
