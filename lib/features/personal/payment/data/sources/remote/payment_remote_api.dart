import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../domain/entities/exchange_rate_entity.dart';
import '../../../domain/params/get_exchange_rate_params.dart';
import '../../models/exchange_rate_model.dart';

abstract interface class PaymentRemoteApi {
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
      GetExchangeRateParams params);
}

class PaymentRemoteApiImpl implements PaymentRemoteApi {
  @override
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
      GetExchangeRateParams params) async {
    const String endpoint = 'payment/get/exchangeRate';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post, // Assuming POST since it has body
        isAuth: false, // Adjust if auth needed
        body: json.encode(params.toJson()),
      );

      if (result is DataSuccess) {
        final String rawData = result.data ?? '';
        if (rawData.isEmpty) {
          return DataFailer<ExchangeRateEntity>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }

        final Map<String, dynamic> jsonMap = json.decode(rawData);
        final ExchangeRateEntity exchangeRate =
            ExchangeRateModel.fromJson(jsonMap);

        return DataSuccess<ExchangeRateEntity>(rawData, exchangeRate);
      } else {
        return DataFailer<ExchangeRateEntity>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      return DataFailer<ExchangeRateEntity>(CustomException(e.toString()));
    }
  }
}
