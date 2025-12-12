import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';

import '../../../domain/entities/exchange_rate_entity.dart';
import '../../../domain/params/get_exchange_rate_params.dart';
import '../../models/exchange_rate_model.dart';
import '../../models/wallet_model.dart';

class TransferFundsParams {
  final String walletId;
  final double amount;
  final String currency;

  TransferFundsParams({
    required this.walletId,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    'wallet_id': walletId,
    'amount': amount,
    'currency': currency,
  };
}

class CreatePayoutParams {
  final String walletId;
  final double amount;
  final String currency;

  CreatePayoutParams({
    required this.walletId,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    'wallet_id': walletId,
    'amount': amount,
    'currency': currency,
  };
}

abstract interface class PaymentRemoteApi {
  Future<DataState<ExchangeRateEntity>> getExchangeRate(
    GetExchangeRateParams params,
  );
  Future<DataState<WalletModel>> getWallet(String id);
  Future<DataState<bool>> transferFunds(TransferFundsParams params);
  Future<DataState<WalletModel>> createPayouts(CreatePayoutParams params);
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
  Future<DataState<WalletModel>> getWallet(String id) async {
    const String endpoint = 'wallet/get';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        body: jsonEncode(<String, String>{'wallet_id': id}),
      );
      if (result is DataSuccess) {
        final String rawData = result.data ?? '';
        AppLog.info('[getWallet] API Success: $rawData');
        final Map<String, dynamic> jsonMap = json.decode(rawData);
        final Map<String, dynamic>? walletJson =
            jsonMap['wallet'] as Map<String, dynamic>?;
        if (walletJson == null) {
          return DataFailer<WalletModel>(
            CustomException('Wallet data missing'),
          );
        }
        final WalletModel wallet = WalletModel.fromJson(walletJson);
        return DataSuccess<WalletModel>(rawData, wallet);
      } else {
        AppLog.error('[getWallet] API Failure: ${result.exception?.message}');
        return DataFailer<WalletModel>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error('[getWallet] API Exception', error: e, stackTrace: stc);
      return DataFailer<WalletModel>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> transferFunds(TransferFundsParams params) async {
    const String endpoint = 'payment/transfer';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toJson()),
      );

      if (result is DataSuccess) {
        final String rawData = result.data ?? '';
        AppLog.info('[transferFunds] API Success: $rawData');
        if (rawData.isEmpty) {
          return DataFailer<bool>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }

        final Map<String, dynamic> jsonMap = json.decode(rawData);
        if (jsonMap.containsKey('success')) {
          final bool success = jsonMap['success'] == true;
          return DataSuccess<bool>(rawData, success);
        }

        // Fallback: if API returns a wallet object assume transfer succeeded
        final Map<String, dynamic>? walletJson =
            jsonMap['wallet'] as Map<String, dynamic>?;
        if (walletJson != null) {
          return DataSuccess<bool>(rawData, true);
        }

        return DataFailer<bool>(CustomException('something_wrong'.tr()));
      } else {
        AppLog.error(
          '[transferFunds] API Failure: ${result.exception?.message}',
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error('[transferFunds] API Exception', error: e, stackTrace: stc);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<WalletModel>> createPayouts(
    CreatePayoutParams params,
  ) async {
    const String endpoint = 'payment/payout';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toJson()),
      );
      if (result is DataSuccess) {
        final String rawData = result.data ?? '';
        AppLog.info('[createPayouts] API Success: $rawData');
        if (rawData.isEmpty) {
          return DataFailer<WalletModel>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }

        final Map<String, dynamic> jsonMap = json.decode(rawData);
        final Map<String, dynamic>? walletJson =
            jsonMap['wallet'] as Map<String, dynamic>?;
        if (walletJson == null) {
          return DataFailer<WalletModel>(
            CustomException('Wallet data missing'),
          );
        }
        final WalletModel wallet = WalletModel.fromJson(walletJson);
        return DataSuccess<WalletModel>(rawData, wallet);
      } else {
        AppLog.error(
          '[createPayouts] API Failure: ${result.exception?.message}',
        );
        return DataFailer<WalletModel>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error('[createPayouts] API Exception', error: e, stackTrace: stc);
      return DataFailer<WalletModel>(CustomException(e.toString()));
    }
  }
}
