import 'package:hive/hive.dart';

import '../../../../../core/enums/core/status_type.dart';
import 'booking_payment_detail_entity.dart';
part 'booking_entity.g.dart';

@HiveType(typeId: 49)
class BookingEntity {
  BookingEntity({
    required this.businessID,
    required this.serviceID,
    required this.bookingID,
    required this.customerID,
    required this.employeeID,
    required this.trackingID,
    required this.status,
    required this.paymentDetail,
    required this.bookedAt,
    required this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.notes,
  }) : inHiveAt = DateTime.now();

  @HiveField(0)
  final String? businessID;
  @HiveField(1)
  final String? serviceID;
  @HiveField(2)
  final String? bookingID;
  @HiveField(3)
  final String customerID;
  @HiveField(4)
  final String employeeID;
  @HiveField(5)
  final String? trackingID;
  @HiveField(6)
  final StatusType status;
  @HiveField(7)
  final BookingPaymentDetailEntity? paymentDetail;
  @HiveField(8)
  final DateTime bookedAt;
  @HiveField(9)
  final DateTime? cancelledAt;
  @HiveField(10)
  final DateTime createdAt;
  @HiveField(11)
  final DateTime updatedAt;
  @HiveField(12)
  final DateTime inHiveAt;
  @HiveField(13)
  final String notes;
}