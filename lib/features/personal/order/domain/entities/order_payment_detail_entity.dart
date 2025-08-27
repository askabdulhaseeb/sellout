import 'package:hive/hive.dart';
part 'order_payment_detail_entity.g.dart';

@HiveType(typeId: 62)
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

  @HiveField(0)
  final String method;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String paymentIndentId;

  @HiveField(6)
  final String transactionChargeCurrency;

  @HiveField(7)
  final double transactionChargePerItem;

  @HiveField(8)
  final String sellerId;

  @HiveField(9)
  final String postCurrency;

  @HiveField(10)
  final double deliveryPrice;
}
