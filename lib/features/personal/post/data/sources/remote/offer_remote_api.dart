
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../postage/data/models/postage_detail_repsonse_model.dart';
import '../../../../basket/data/models/cart/add_shipping_response_model.dart';
import '../../../domain/entities/offer/offer_payment_response.dart';
import '../../../domain/params/create_offer_params.dart';
import '../../../domain/params/buy_now_add_shipping_param.dart';
import '../../../domain/params/buy_now_shipping_rates_params.dart';
import '../../../domain/params/offer_payment_params.dart';
import '../../../domain/params/update_offer_params.dart';

abstract interface class OfferRemoteApi {
  Future<DataState<bool>> createOffer(CreateOfferparams param);
  Future<DataState<bool>> updateOffer(UpdateOfferParams param);
  Future<DataState<OfferPaymentResponse>> offerPayment(
    OfferPaymentParams param,
  );
  Future<DataState<PostageDetailResponseModel>> getBuyNowShippingRates(
    BuyNowShippingRatesParams param,
  );
  Future<DataState<AddShippingResponseModel>> addBuyNowShipping(
    BuyNowAddShippingParam param,
  );
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
        AppLog.info(
          '${result.data}',
          name: 'OfferRemoteApi.updateOffer - success',
        );
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
  Future<DataState<OfferPaymentResponse>> offerPayment(
    OfferPaymentParams param,
  ) async {
    const String endpoint = '/payment/buy-now';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );
      if (result is DataSuccess) {
        final Map<String, dynamic> data =
            jsonDecode(result.data ?? '{}') as Map<String, dynamic>;
        final OfferPaymentResponse response = OfferPaymentResponse.fromJson(
          data,
        );
        debugPrint('✅ Buy-now payment success: ${response.offerId}');

        return DataSuccess<OfferPaymentResponse>(result.data ?? '{}', response);
      } else {
        debugPrint('❌ Buy-now payment failed at response stage');
        AppLog.error(
          result.exception?.reason ?? 'Unknown error during buy-now payment',
          name:
              'PostRemoteApiImpl.offerPayment - else ,Status code:${result.data}}',
          error: result.exception?.detail,
        );
        return DataFailer<OfferPaymentResponse>(
          CustomException(result.exception?.message ?? 'something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      debugPrint('🔥 Exception during buy-now payment');
      debugPrint('❗ Params causing issue: ${param.toMap()}');
      debugPrint('❗ Error: $e');

      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.offerPayment - catch',
        error: e,
        stackTrace: stc,
      );

      return DataFailer<OfferPaymentResponse>(
        CustomException('something_wrong'.tr()),
      );
    }
  }

  @override
  Future<DataState<PostageDetailResponseModel>> getBuyNowShippingRates(
    BuyNowShippingRatesParams param,
  ) async {
    const String endpoint = '/buy-now/shipping-rates';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );

      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty buy-now shipping rates response',
            name: 'OfferRemoteApiImpl.getBuyNowShippingRates - Empty',
          );
          return DataFailer<PostageDetailResponseModel>(
            CustomException('something_wrong'.tr()),
          );
        }

        try {
          final dynamic decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            final PostageDetailResponseModel model =
                PostageDetailResponseModel.fromJson(decoded);
            return DataSuccess<PostageDetailResponseModel>(raw, model);
          }
        } catch (e) {
          AppLog.error(
            'Parse error: $e',
            name: 'OfferRemoteApiImpl.getBuyNowShippingRates - Parse',
            error: e,
          );
        }

        return DataFailer<PostageDetailResponseModel>(
          CustomException('something_wrong'.tr()),
        );
      }

      AppLog.error(
        result.exception?.reason ?? 'Unknown error during buy-now rates',
        name: 'OfferRemoteApiImpl.getBuyNowShippingRates - Else',
        error: result.exception?.detail,
      );
      return DataFailer<PostageDetailResponseModel>(
        CustomException(result.exception?.message ?? 'something_wrong'.tr()),
      );
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OfferRemoteApiImpl.getBuyNowShippingRates - Catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<PostageDetailResponseModel>(
        CustomException('something_wrong'.tr()),
      );
    }
  }

  @override
  Future<DataState<AddShippingResponseModel>> addBuyNowShipping(
    BuyNowAddShippingParam param,
  ) async {
    const String endpoint = '/buy-now/add/shipping';

    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );

      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          AppLog.error(
            'Empty addBuyNowShipping response',
            name: 'OfferRemoteApiImpl.addBuyNowShipping - Empty',
          );
          return DataFailer<AddShippingResponseModel>(
            CustomException('something_wrong'.tr()),
          );
        }

        try {
          final dynamic decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            final AddShippingResponseModel model =
                AddShippingResponseModel.fromJson(decoded);
            return DataSuccess<AddShippingResponseModel>(raw, model);
          }
        } catch (e) {
          AppLog.error(
            'Parse error: $e',
            name: 'OfferRemoteApiImpl.addBuyNowShipping - Parse',
            error: e,
          );
        }

        return DataFailer<AddShippingResponseModel>(
          CustomException('something_wrong'.tr()),
        );
      }

      AppLog.error(
        result.exception?.reason ?? 'Unknown error during add buy-now shipping',
        name: 'OfferRemoteApiImpl.addBuyNowShipping - Else',
        error: result.exception?.detail,
      );
      return DataFailer<AddShippingResponseModel>(
        CustomException(result.exception?.message ?? 'something_wrong'.tr()),
      );
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OfferRemoteApiImpl.addBuyNowShipping - Catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<AddShippingResponseModel>(
        CustomException('something_wrong'.tr()),
      );
    }
  }
}
