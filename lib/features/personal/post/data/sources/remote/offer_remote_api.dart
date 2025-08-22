import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../domain/params/create_offer_params.dart';
import '../../../domain/params/offer_payment_params.dart';
import '../../../domain/params/update_offer_params.dart';

abstract interface class OfferRemoteApi {
  Future<DataState<bool>> createOffer(CreateOfferparams param);
  Future<DataState<bool>> updateOffer(UpdateOfferParams param);
  Future<DataState<String>> offerPayment(OfferPaymentParams param);
}

class OfferRemoteApiImpl implements OfferRemoteApi {
  @override
  Future<DataState<bool>> createOffer(CreateOfferparams param) async {
    const String endpoint = '/offers/create';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );
      if (result is DataSuccess) {
        final Map<String, dynamic> data = jsonDecode(result.data ?? '');
        final String chatID = data['chat_id'];
        return DataSuccess<bool>(chatID, true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'ERROR - PostRemoteApiImpl.createOffer',
          name: 'PostRemoteApiImpl.createOffer - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.createOffer - catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> updateOffer(UpdateOfferParams param) async {
    String endpoint = '/offers/update/${param.offerId}';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        isAuth: true,
        body: json.encode(param.toMap()),
      );
      if (result is DataSuccess) {
        AppLog.info('${result.data}',
            name: 'OfferRemoteApi.updateOffer - success');
        return DataSuccess<bool>(result.data!, true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'PostRemoteApiImpl.updateOffer - else',
          name: 'PostRemoteApiImpl.updateOffer - else',
          error: result.exception?.reason,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.updateOffer - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> offerPayment(OfferPaymentParams param) async {
    const String endpoint = '/payment/offer';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );
      if (result is DataSuccess) {
        debugPrint('✅ Offer payment success: ${result.data}');
        final Map<String, dynamic> data = jsonDecode(result.data ?? '');
        final String clientSecret = data['clientSecret'];
        return DataSuccess<String>(result.data!, clientSecret);
      } else {
        debugPrint('❌ Offer payment failed at response stage');
        AppLog.error(
          result.exception?.message ?? 'Unknown error during offer payment',
          name: 'PostRemoteApiImpl.offerPayment - else',
          error: result.exception,
        );
        return DataFailer<String>(
          CustomException(result.exception?.message ?? 'something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      debugPrint('🔥 Exception during offer payment');
      debugPrint('❗ Params causing issue: ${param.toMap()}');
      debugPrint('❗ Error: $e');

      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.offerPayment - catch',
        error: e,
        stackTrace: stc,
      );

      return DataFailer<String>(
        CustomException('something_wrong'.tr()),
      );
    }
  }
}
