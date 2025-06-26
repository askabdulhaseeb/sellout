import '../../domain/entities/order_payment_detail_entity.dart';

class OrderPaymentDetailModel extends OrderPaymentDetailEntity {
  factory OrderPaymentDetailModel.fromEntity(OrderPaymentDetailEntity entity) {
    return OrderPaymentDetailModel(
      method: entity.method,
      status: entity.status,
      timestamp: entity.timestamp,
      quantity: entity.quantity,
      price: entity.price,
      paymentIndentId: entity.paymentIndentId,
      transactionChargeCurrency: entity.transactionChargeCurrency,
      transactionChargePerItem: entity.transactionChargePerItem,
      sellerId: entity.sellerId,
      postCurrency: entity.postCurrency,
      deliveryPrice: entity.deliveryPrice,
    );
  }
  const OrderPaymentDetailModel({
    required super.method,
    required super.status,
    required super.timestamp,
    required super.quantity,
    required super.price,
    required super.paymentIndentId,
    required super.transactionChargeCurrency,
    required super.transactionChargePerItem,
    required super.sellerId,
    required super.postCurrency,
    required super.deliveryPrice,
  });

  factory OrderPaymentDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentDetailModel(
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      quantity: json['quantity'] ?? 0,
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      paymentIndentId: json['payment_indent_id'] ?? '',
      transactionChargeCurrency: json['transaction_charge_currency'] ?? '',
      transactionChargePerItem: (json['transaction_charge_per_item'] is num)
          ? (json['transaction_charge_per_item'] as num).toDouble()
          : 0.0,
      sellerId: json['seller_id'] ?? '',
      postCurrency: json['post_currency'] ?? '',
      deliveryPrice: (json['delivery_price'] is num)
          ? (json['delivery_price'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'quantity': quantity,
      'price': price,
      'payment_indent_id': paymentIndentId,
      'transaction_charge_currency': transactionChargeCurrency,
      'transaction_charge_per_item': transactionChargePerItem,
      'seller_id': sellerId,
      'post_currency': postCurrency,
      'delivery_price': deliveryPrice,
    };
  }
}
