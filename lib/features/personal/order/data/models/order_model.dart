import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/order_entity.dart';
import 'order_payment_detail_model.dart';

class OrderModel extends OrderEntity {
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: json['order_id'] ?? '',
        buyerId: json['buyer_id'] ?? '',
        sellerId: json['seller_id'] ?? '',
        postId: json['post_id'] ?? '',
        orderStatus: StatusType.fromJson(json['order_status']),
        orderType: json['order_type'] ?? '',
        price: (json['price'] as num).toDouble(),
        totalAmount: (json['total_amount'] as num).toDouble(),
        quantity: json['quantity'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        paymentDetail: OrderPaymentDetailModel.fromJson(json['payment_detail']),
        shippingAddress: AddressModel.fromJson(json['shipping_address']),
        businessId: json['business_id'] ?? 'null');
  }
  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
        orderId: entity.orderId,
        buyerId: entity.buyerId,
        sellerId: entity.sellerId,
        postId: entity.postId,
        orderStatus: entity.orderStatus,
        orderType: entity.orderType,
        price: entity.price,
        totalAmount: entity.totalAmount,
        quantity: entity.quantity,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        paymentDetail: OrderPaymentDetailModel.fromEntity(entity.paymentDetail),
        shippingAddress: AddressModel.fromEntity(entity.shippingAddress),
        businessId: entity.businessId);
  }
  const OrderModel({
    required super.orderId,
    required super.buyerId,
    required super.sellerId,
    required super.postId,
    required super.orderStatus,
    required super.orderType,
    required super.price,
    required super.totalAmount,
    required super.quantity,
    required super.createdAt,
    required super.updatedAt,
    required super.paymentDetail,
    required super.shippingAddress,
    required super.businessId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'business_id': businessId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'post_id': postId,
      'order_status': orderStatus,
      'order_type': orderType,
      'price': price,
      'total_amount': totalAmount,
      'quantity': quantity,
      'payment_detail': OrderPaymentDetailModel.fromEntity(paymentDetail)
          .toJson(), // Payment detail already properly typed
      'shipping_address': AddressModel.fromEntity(shippingAddress)
          .shippingAddressToJson() // Ensure AddressModel has toJson method
    };
  }
}
