import '../../../domain/entities/checkout/billing_details_entity.dart';

class BillingDetailsModel extends BillingDetailsEntity {
  const BillingDetailsModel({
    required super.subtotal,
    required super.deliveryTotal,
    required super.grandTotal,
    required super.currency,
  });

  factory BillingDetailsModel.fromJson(Map<String, dynamic> json) =>
      BillingDetailsModel(
        subtotal: json['subtotal'] ?? '',
        deliveryTotal: json['deliveryTotal'] ?? '',
        grandTotal: json['grandTotal'] ?? '',
        currency: json['currency'] ?? '',
      );
}
