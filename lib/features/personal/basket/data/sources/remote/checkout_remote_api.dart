import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../domain/entities/checkout/payment_intent_entity.dart';
import '../../models/checkout/payment_intent_model.dart';

abstract interface class CheckoutRemoteAPI {
  Future<DataState<PaymentIntentEntity>> cartPayIntent();
}

class CheckoutRemoteAPIImpl implements CheckoutRemoteAPI {
  @override
  Future<DataState<PaymentIntentEntity>> cartPayIntent() async {
    try {
      const String endpoint = '/payment/cart';
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        isAuth: true,
        requestType: ApiRequestType.post,
      );
      if (result is DataSuccess<String>) {
        final PaymentIntentEntity paymentIntent =
            PaymentIntentModel.fromRawJson(result.data ?? '');
        AppLog.info(result.data.toString());
        AppLog.info('Payment intent created successfully',
            name: 'CheckoutRemoteAPIImpl.cartPayIntent - success');
        return DataSuccess<PaymentIntentEntity>(
            result.data ?? '', paymentIntent);
      } else {
        AppLog.error(
          '',
          name: 'CheckoutRemoteAPIImpl.cartPayIntent - Else',
          error: result.exception?.reason ?? 'something_wrong'.tr(),
        );
        return DataFailer<PaymentIntentEntity>(
            CustomException('Failed to create payment intent'));
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        stackTrace: stc,
        name: 'CheckoutRemoteAPIImpl.cartPayIntent - Catch',
        error: e,
      );
      return DataFailer<PaymentIntentEntity>(CustomException(e.toString()));
    }
  }
}
