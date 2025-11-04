import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/checkout/check_out_entity.dart';
import '../../models/checkout/check_out_model.dart';

abstract interface class CheckoutRemoteAPI {
  Future<DataState<CheckOutEntity>> getCheckout(AddressModel address);
  Future<DataState<String>> cartPayIntent(AddressModel param);
  Future<DataState<String>> getPostage(AddressModel param);
}

class CheckoutRemoteAPIImpl implements CheckoutRemoteAPI {
  @override
  Future<DataState<CheckOutEntity>> getCheckout(AddressModel address) async {
    try {
      const String endpoint = '/cart/checkout';
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: address.checkoutAddressToJson(),
      );
      if (result is DataSuccess) {
        return DataSuccess<CheckOutEntity>(
          result.data ?? '',
          CheckOutModel.fromRawJson(result.data ?? ''),
        );
      } else {
        AppLog.error(
          address.checkoutAddressToJson(),
          name: 'CheckoutRemoteAPIImpl.getCheckout - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<CheckOutEntity>(
            result.exception ?? CustomException('something_wrong'.tr()));
      }
    } catch (e) {
      AppLog.error(
        'Failed to get checkout',
        name: 'CheckoutRemoteAPIImpl.getCheckout - Catch',
        error: e,
      );
    }
    return DataFailer<CheckOutEntity>(CustomException('something_wrong'.tr()));
  }

  @override
  Future<DataState<String>> cartPayIntent(AddressModel param) async {
    try {
      debugPrint(LocalAuth.token);
      const String endpoint = '/payment/cart';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: param.checkoutAddressToJson(),
      );
      if (result is DataSuccess<String>) {
        final Map<String, dynamic> responseMap = jsonDecode(result.data ?? '');
        final String clientSecret = responseMap['clientSecret'];
        AppLog.info('Payment successful',
            name: 'CheckoutRemoteAPIImpl.cartPayIntent - if');
        return DataSuccess<String>(result.data ?? '', clientSecret);
      } else {
        AppLog.error(
          param.checkoutAddressToJson(),
          name: 'CheckoutRemoteAPIImpl.payIntent - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<String>(
            CustomException('Failed to add payment Address'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CheckoutRemoteAPIImpl.paymentAddress - Catch',
        error: e,
      );
      return DataFailer<String>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> getPostage(AddressModel param) async {
    try {
      debugPrint(LocalAuth.token);
      const String endpoint = '/cart/get/postage';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
        body: param.checkoutAddressToJson(),
      );
      if (result is DataSuccess<String>) {
        final Map<String, dynamic> responseMap = jsonDecode(result.data ?? '');
        final String clientSecret = responseMap['clientSecret'];
        AppLog.info('Payment successful',
            name: 'CheckoutRemoteAPIImpl.cartPayIntent - if');
        return DataSuccess<String>(result.data ?? '', clientSecret);
      } else {
        AppLog.error(
          param.checkoutAddressToJson(),
          name: 'CheckoutRemoteAPIImpl.payIntent - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<String>(
            CustomException('Failed to add payment Address'));
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'CheckoutRemoteAPIImpl.paymentAddress - Catch',
        error: e,
      );
      return DataFailer<String>(CustomException(e.toString()));
    }
  }
}
