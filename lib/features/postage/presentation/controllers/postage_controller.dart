import 'package:easy_localization/easy_localization.dart';
import '../../../../core/sources/data_state.dart';
import '../../../personal/basket/data/models/cart/add_shipping_response_model.dart';
import '../../../personal/basket/domain/entities/checkout/payment_intent_entity.dart';
import '../../../personal/basket/views/providers/cart_provider.dart';

/// Orchestrates postage submission followed by billing retrieval.
/// Keeps UI widgets lightweight and focused on rendering.
class PostageController {
  Future<DataState<void>> submitPostageAndFetchBilling(
    CartProvider cartPro,
  ) async {
    // Submit selected shipping
    final DataState<AddShippingResponseModel> submitState = await cartPro
        .submitShipping();

    if (submitState is! DataSuccess<AddShippingResponseModel>) {
      return DataFailer<void>(
        submitState.exception ??
            CustomException('failed_to_submit_shipping'.tr()),
      );
    }

    // Retrieve billing details for review page
    final DataState<PaymentIntentEntity> billingState = await cartPro
        .getBillingDetails();

    if (billingState is! DataSuccess<PaymentIntentEntity>) {
      return DataFailer<void>(
        billingState.exception ?? CustomException('failed_to_get_billing'.tr()),
      );
    }

    return DataSuccess<void>('ok', null);
  }
}
