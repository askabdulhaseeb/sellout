import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/order_entity.dart';
import 'order_payment_detail_model.dart';
import 'shipping_detail_model.dart';


class OrderModel extends OrderEntity {
  OrderModel({
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
    required super.businessId,
    required super.paymentDetail,
    required super.shippingAddress,
    super.size,
    super.color,
    super.listId,
    super.isBusinessOrder,
    super.transactionId,
    super.trackId,
    super.deliveryPaidBy,
    super.shippingDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      postId: json['post_id'] ?? '',
      orderStatus: StatusType.fromJson(json['order_status'] ?? 'pending'),
      orderType: json['order_type'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      totalAmount: (json['total_amount'] is num)
          ? (json['total_amount'] as num).toDouble()
          : 0.0,
      quantity: json['quantity'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
      paymentDetail: OrderPaymentDetailModel.fromJson(
        json['payment_detail'] ?? <String, dynamic>{},
      ),
      shippingAddress: json['shipping_address'] != null
          ? AddressModel.fromJson(json['shipping_address'])
          : AddressModel.fromJson(<String, dynamic>{}),
      businessId: json['business_id'] ?? '',
      size: json['size'],
      color: json['color'],
      listId: json['list_id'],
      isBusinessOrder: json['is_business_order'],
      transactionId: json['transaction_id'],
      trackId: json['track_id'],
      deliveryPaidBy: json['delivery_paid_by'],
      shippingDetails: json['shipping_detail'] != null
          ? ShippingDetailModel.fromJson(json['shipping_detail'])
          : null,
    );
  }

  factory OrderModel.fromEntity(OrderEntity e) {
    return OrderModel(
      orderId: e.orderId,
      buyerId: e.buyerId,
      sellerId: e.sellerId,
      postId: e.postId,
      orderStatus: e.orderStatus,
      orderType: e.orderType,
      price: e.price,
      totalAmount: e.totalAmount,
      quantity: e.quantity,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      paymentDetail: OrderPaymentDetailModel.fromEntity(e.paymentDetail),
      shippingAddress: AddressModel.fromEntity(e.shippingAddress),
      businessId: e.businessId,
      size: e.size,
      color: e.color,
      listId: e.listId,
      isBusinessOrder: e.isBusinessOrder,
      transactionId: e.transactionId,
      trackId: e.trackId,
      deliveryPaidBy: e.deliveryPaidBy,
      shippingDetails: e.shippingDetails != null
          ? ShippingDetailModel.fromEntity(e.shippingDetails!)
          : null,
    );
  }
}
