import 'package:hive_ce/hive.dart';
import '../../../../../core/enums/core/status_type.dart';
part 'booking_payment_detail_entity.g.dart';

@HiveType(typeId: 50)
class BookingPaymentDetailEntity {
  BookingPaymentDetailEntity({
    required this.transactionID,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });

  @HiveField(0)
  final String? transactionID;
  @HiveField(1)
  final StatusType? status;
  @HiveField(2)
  final DateTime? updatedAt;
  @HiveField(3)
  final DateTime? createdAt;
}
