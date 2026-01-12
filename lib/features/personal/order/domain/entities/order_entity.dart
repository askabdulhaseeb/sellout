import 'package:hive_ce/hive.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';
import 'order_payment_detail_entity.dart';
import 'shipping_detail_entity.dart';

part 'order_entity.g.dart';

@HiveType(typeId: 61)
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
    this.size,
    this.color,
    this.listId,
    this.isBusinessOrder,
    this.transactionId,
    this.trackId,
    this.deliveryPaidBy,
    this.shippingDetails,
  });

  @HiveField(0)
  final String orderId;

  @HiveField(1)
  final String buyerId;

  @HiveField(2)
  final String sellerId;

  @HiveField(3)
  final String postId;

  @HiveField(4)
  final StatusType orderStatus;

  @HiveField(5)
  final String orderType;

  @HiveField(6)
  final double price;

  @HiveField(7)
  final double totalAmount;

  @HiveField(8)
  final int quantity;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final OrderPaymentDetailEntity paymentDetail;

  @HiveField(12)
  final AddressEntity shippingAddress;

  @HiveField(13)
  final String businessId;

  @HiveField(14)
  final String? size;

  @HiveField(15)
  final String? color;

  @HiveField(16)
  final String? listId;

  @HiveField(17)
  final bool? isBusinessOrder;

  @HiveField(18)
  final String? transactionId;

  @HiveField(19)
  final String? trackId;

  @HiveField(20)
  final String? deliveryPaidBy;

  @HiveField(21)
  final ShippingDetailEntity? shippingDetails;

  OrderEntity copyWith({
    String? orderId,
    String? buyerId,
    String? sellerId,
    String? postId,
    StatusType? orderStatus,
    String? orderType,
    double? price,
    double? totalAmount,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderPaymentDetailEntity? paymentDetail,
    AddressEntity? shippingAddress,
    String? businessId,
    String? size,
    String? color,
    String? listId,
    bool? isBusinessOrder,
    String? transactionId,
    String? trackId,
    String? deliveryPaidBy,
    ShippingDetailEntity? shippingDetail,
  }) {
    return OrderEntity(
      shippingDetails: shippingDetail ?? this.shippingDetails,
      orderId: orderId ?? this.orderId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      postId: postId ?? this.postId,
      orderStatus: orderStatus ?? this.orderStatus,
      orderType: orderType ?? this.orderType,
      price: price ?? this.price,
      totalAmount: totalAmount ?? this.totalAmount,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentDetail: paymentDetail ?? this.paymentDetail,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      businessId: businessId ?? this.businessId,
      size: size ?? this.size,
      color: color ?? this.color,
      listId: listId ?? this.listId,
      isBusinessOrder: isBusinessOrder ?? this.isBusinessOrder,
      transactionId: transactionId ?? this.transactionId,
      trackId: trackId ?? this.trackId,
      deliveryPaidBy: deliveryPaidBy ?? this.deliveryPaidBy,
    );
  }
}
