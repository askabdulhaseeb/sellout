import 'package:hive/hive.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import 'order_payment_detail_entity.dart';
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
}
