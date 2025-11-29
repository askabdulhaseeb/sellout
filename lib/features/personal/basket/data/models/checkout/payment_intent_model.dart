import 'dart:convert';
import '../../../domain/entities/checkout/payment_intent_entity.dart';
import 'billing_details_model.dart';
import 'payment_item_model.dart';

class PaymentIntentModel extends PaymentIntentEntity {
  const PaymentIntentModel({
    required super.clientSecret,
    required super.billingDetails,
    required super.items,
  });

  factory PaymentIntentModel.fromRawJson(String str) =>
      PaymentIntentModel.fromJson(json.decode(str));

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      PaymentIntentModel(
        clientSecret: json['clientSecret'] ?? '',
        billingDetails: BillingDetailsModel.fromJson(json['billingDetails']),
        items: List<PaymentItemModel>.from((json['items'] ?? <dynamic>[])
            .map((dynamic x) => PaymentItemModel.fromJson(x))),
      );
}
