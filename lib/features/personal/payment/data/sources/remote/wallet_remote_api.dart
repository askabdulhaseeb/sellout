import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../domain/params/create_payout_params.dart';
import '../../../domain/params/transfer_funds_params.dart';
import '../../models/wallet_model.dart';
import '../../../../../../core/sources/data_state.dart';

abstract interface class WalletRemoteApi {
  Future<DataState<WalletModel>> getWallet(String id);
  Future<DataState<bool>> transferFunds(TransferFundsParams params);
  Future<DataState<bool>> createPayouts(CreatePayoutParams params);
}

class WalletRemoteApiImpl implements WalletRemoteApi {
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
    const String endpoint = '/payment/transfer';
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

        // final Map<String, dynamic> jsonMap = json.decode(rawData);
        AppLog.info(rawData);
        // if (jsonMap.containsKey('success')) {
        //   final bool success = jsonMap['success'] == true;
        //   return DataSuccess<bool>(rawData, success);
        // }

        // Fallback: if API returns a wallet object assume transfer succeeded
        // final Map<String, dynamic>? walletJson =
        //     jsonMap['wallet'] as Map<String, dynamic>?;
        // if (walletJson != null) {
        return DataSuccess<bool>(rawData, true);
        // }

        // return DataFailer<bool>(CustomException('something_wrong'.tr()));
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
  Future<DataState<bool>> createPayouts(CreatePayoutParams params) async {
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
          return DataFailer<bool>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }
        return DataSuccess<bool>(rawData, false);
      } else {
        AppLog.error(
          '[createPayouts] API Failure: ${result.exception?.message}',
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error('[createPayouts] API Exception', error: e, stackTrace: stc);
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
