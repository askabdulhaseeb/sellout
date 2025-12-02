import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../domain/entities/exchange_rate_entity.dart';
import '../../../domain/params/get_exchange_rate_params.dart';
import '../../models/exchange_rate_model.dart';

abstract interface class PaymentRemoteApi {
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
    GetExchangeRateParams params,
  );
  Future<DataState<bool>> getWallet(String id);
}

class PaymentRemoteApiImpl implements PaymentRemoteApi {
  @override
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
    GetExchangeRateParams params,
  ) async {
    if (params.from == params.to) {
      const ExchangeRateEntity exchangeRate = ExchangeRateEntity(rate: 1.0);
      return DataSuccess<ExchangeRateEntity>('', exchangeRate);
    }

    const String endpoint = 'payment/get/exchangeRate';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toJson()),
      );

      if (result is DataSuccess) {
        final String rawData = result.data ?? '';
        if (rawData.isEmpty) {
          AppLog.info(
            'Empty exchange rate data received from API',
            name: 'PaymentRemoteApiImpl.getExchangeRate',
          );
          return DataFailer<ExchangeRateEntity>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }

        final Map<String, dynamic> jsonMap = json.decode(rawData);
        final ExchangeRateEntity exchangeRate = ExchangeRateModel.fromJson(
          jsonMap,
        );
        AppLog.info(
          'Empty exchange rate data received from API',
          name: 'PaymentRemoteApiImpl.getExchangeRate - success',
        );
        return DataSuccess<ExchangeRateEntity>(rawData, exchangeRate);
      } else {
        AppLog.error(
          'Empty exchange rate data received from API',
          name: 'PaymentRemoteApiImpl.getExchangeRate - failure',
        );
        return DataFailer<ExchangeRateEntity>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        'Empty exchange rate data received from API',
        name: 'PaymentRemoteApiImpl.getExchangeRate - catch',
        error: e,
        stackTrace: stc,
      );

      return DataFailer<ExchangeRateEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> getWallet(String id) async {
    final String endpoint = '/wallet/get/$id';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
      );
      if (result is DataSuccess) {
        final String rawData = result.data ?? '';
        AppLog.info('[getWallet] API Success: $rawData');
        return DataSuccess<bool>(rawData, true);
      } else {
        AppLog.error('[getWallet] API Failure: ${result.exception?.message}');
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error('[getWallet] API Exception', error: e, stackTrace: stc);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
