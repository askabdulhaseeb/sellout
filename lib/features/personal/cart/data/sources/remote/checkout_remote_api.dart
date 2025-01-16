import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../../domain/entities/checkout/check_out_entity.dart';
import '../../models/checkout/check_out_model.dart';

abstract interface class CheckoutRemoteAPI {
  Future<DataState<CheckOutEntity>> getCheckout(AddressModel address);
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
          'Failed to get checkout',
          name: 'CheckoutRemoteAPIImpl.getCheckout - Else',
          error: result.exception,
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
}
