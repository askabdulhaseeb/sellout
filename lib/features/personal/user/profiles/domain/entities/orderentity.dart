import '../../../../auth/signin/data/models/address_model.dart';

class OrderEntity {
  const OrderEntity({
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.postId,
    required this.orderStatus,
    required this.orderType,
    required this.price,
    required this.totalAmount,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentDetail,
    required this.shippingAddress,
    required this.businessId,
  });
  final String orderId;
  final String buyerId;
  final String sellerId;
  final String postId;
  final String orderStatus;
  final String orderType;
  final double price;
  final double totalAmount;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderPaymentDetailEntity paymentDetail;
  final AddressEntity shippingAddress;
  final String businessId;
}

class OrderPaymentDetailEntity {
  const OrderPaymentDetailEntity({
    required this.method,
    required this.status,
    required this.timestamp,
    required this.quantity,
    required this.price,
    required this.paymentIndentId,
    required this.transactionChargeCurrency,
    required this.transactionChargePerItem,
    required this.sellerId,
    required this.postCurrency,
    required this.deliveryPrice,
  });

  final String method;
  final String status;
  final DateTime timestamp;
  final int quantity;
  final double price;
  final String paymentIndentId;
  final String transactionChargeCurrency;
  final double transactionChargePerItem;
  final String sellerId;
  final String postCurrency;
  final double deliveryPrice;
}
