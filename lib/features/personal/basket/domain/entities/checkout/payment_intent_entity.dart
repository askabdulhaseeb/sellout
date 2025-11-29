import 'billing_details_entity.dart';
import 'payment_item_entity.dart';

class PaymentIntentEntity {
  const PaymentIntentEntity({
    required this.clientSecret,
    required this.billingDetails,
    required this.items,
  });

  final String clientSecret;
  final BillingDetailsEntity billingDetails;
  final List<PaymentItemEntity> items;
}
