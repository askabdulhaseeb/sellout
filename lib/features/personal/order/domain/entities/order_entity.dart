import 'package:hive/hive.dart';
import '../../../auth/signin/data/models/address_model.dart';
import 'order_payment_detail_entity.dart';
part '../../../user/profiles/domain/entities/order_entity.g.dart';

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
  final String orderStatus;

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

  OrderEntity copyWith({
    String? orderId,
    String? buyerId,
    String? sellerId,
    String? postId,
    String? orderStatus,
    String? orderType,
    double? price,
    double? totalAmount,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderPaymentDetailEntity? paymentDetail,
    AddressEntity? shippingAddress,
    String? businessId,
  }) {
    return OrderEntity(
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
    );
  }
}
