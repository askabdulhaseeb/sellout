import 'package:hive_ce/hive.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../order/domain/entities/order_payment_detail_entity.dart';
part 'notification_metadata_entity.g.dart';

class NotificationPaymentDetail {
  final double? originalPrice;
  final int? quantity;
  final String? paymentIntentId;
  final String? method;
  final String? transactionChargeCurrency;
  final double? transactionChargePerItem;
  final double? convertedDeliveryPrice;
  final double? coreDeliveryPrice;
  final double? convertedPrice;
  final double? netChargePerItem;
  final String? buyerCurrency;
  final String? sellerId;
  final String? postCurrency;
  final String? status;
  final DateTime? timestamp;

  NotificationPaymentDetail({
    this.originalPrice,
    this.quantity,
    this.paymentIntentId,
    this.method,
    this.transactionChargeCurrency,
    this.transactionChargePerItem,
    this.convertedDeliveryPrice,
    this.coreDeliveryPrice,
    this.convertedPrice,
    this.netChargePerItem,
    this.buyerCurrency,
    this.sellerId,
    this.postCurrency,
    this.status,
    this.timestamp,
  });

  factory NotificationPaymentDetail.fromJson(Map<String, dynamic> json) {
    return NotificationPaymentDetail(
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      paymentIntentId: json['payment_intent_id'] as String?,
      method: json['method'] as String?,
      transactionChargeCurrency: json['transaction_charge_currency'] as String?,
      transactionChargePerItem: (json['transaction_charge_per_item'] as num?)
          ?.toDouble(),
      convertedDeliveryPrice: (json['converted_delivery_price'] as num?)
          ?.toDouble(),
      coreDeliveryPrice: (json['core_delivery_price'] as num?)?.toDouble(),
      convertedPrice: (json['converted_price'] as num?)?.toDouble(),
      netChargePerItem: (json['net_charge_per_item'] as num?)?.toDouble(),
      buyerCurrency: json['buyer_currency'] as String?,
      sellerId: json['seller_id'] as String?,
      postCurrency: json['post_currency'] as String?,
      status: json['status'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }
}

@HiveType(typeId: 66)
class NotificationMetadataEntity {
  NotificationMetadataEntity({
    this.postId,
    this.orderId,
    this.chatId,
    this.trackId,
    this.senderId,
    this.messageId,
    this.status,
    this.createdAt,
    this.paymentDetail,
    this.quantity,
    this.totalAmount,
    this.currency,
    this.itemTitle,
    this.event,
  });

  @HiveField(0)
  final String? postId;

  @HiveField(1)
  final String? orderId;

  @HiveField(2)
  final String? chatId;

  @HiveField(3)
  final String? trackId;

  @HiveField(4)
  final String? senderId;

  @HiveField(5)
  final String? messageId;

  @HiveField(6)
  final StatusType? status;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final OrderPaymentDetailEntity? paymentDetail;

  @HiveField(9)
  final int? quantity;

  @HiveField(10)
  final double? totalAmount;

  @HiveField(11)
  final String? currency;

  @HiveField(12)
  final String? itemTitle;

  @HiveField(13)
  final String? event;

  bool get hasOrder => orderId != null && orderId!.isNotEmpty;
  bool get isSeller => paymentDetail?.sellerId == LocalAuth.uid;
  bool get hasPost => postId != null && postId!.isNotEmpty;
  bool get hasChat => chatId != null && chatId!.isNotEmpty;
}
