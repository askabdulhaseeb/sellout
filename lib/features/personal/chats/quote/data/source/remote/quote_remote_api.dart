import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../domain/params/hold_quote_pay_params.dart';
import '../../../domain/params/request_quote_service_params.dart';
import '../../../domain/params/update_quote_params.dart';

abstract class QuoteRemoteDataSource {
  Future<DataState<bool>> requestQuote(RequestQuoteParams params);
  Future<DataState<bool>> updateQuote(UpdateQuoteParams params);
  Future<DataState<bool>> createQuote(bool params); // buisness related api
  Future<DataState<bool>> holdQuotePayment(HoldQuotePayParams params);
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
        AppLog.info(result.data ?? '',
            name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - success');
        final Map<dynamic, dynamic> responseMap = jsonDecode(result.data ?? '');
        final String chatId = responseMap['chat_id'];
        return DataSuccess<bool>(chatId, true);
      } else {
        AppLog.error(
          'somehting_wrong'.tr(),
          name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - failer',
          error: result.exception?.message ?? '',
        );
        return DataFailer<bool>(CustomException('Failed to request quote'));
      }
    } catch (e, stc) {
      AppLog.error('',
          name: 'RequestQuoteRemoteDataSourceImpl.requestQuote - catch',
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
        body: params.toJson(),
      );
      if (result is DataSuccess<bool>) {
        return DataSuccess<bool>('', true);
      } else {
        AppLog.error(params.toJson(),
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

  @override
  Future<DataState<bool>> holdQuotePayment(HoldQuotePayParams params) async {
    try {
      const String endpoint = '/payment/quote';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
        isAuth: true,
        isConnectType: true,
      );
      if (result is DataSuccess) {
        AppLog.info(result.data.toString(),
            name: 'AppointmnetApi.holdQuotePayment - if');
        return DataSuccess<bool>(result.data ?? '', false);
      } else {
        AppLog.error(result.exception?.message ?? 'something_wrong'.tr(),
            name: 'AppointmnetApi.holdQuotePayment - else',
            error: result.exception?.reason);
        return DataFailer<bool>(result.exception!);
      }
    } catch (e) {
      AppLog.error('something_wrong'.tr(),
          name: 'AppointmnetApi.holdQuotePayment - catch');
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
