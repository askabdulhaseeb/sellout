import 'package:flutter/material.dart';

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
}
class OrderPaymentDetailEntity {
  final String transactionId;
  final String method;
  final String status;
  final DateTime timestamp;

  const OrderPaymentDetailEntity({
    required this.transactionId,
    required this.method,
    required this.status,
    required this.timestamp,
  });
}