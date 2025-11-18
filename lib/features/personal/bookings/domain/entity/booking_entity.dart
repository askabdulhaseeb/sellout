import 'package:hive/hive.dart';

import '../../../../../core/enums/core/status_type.dart';
import '../../../auth/signin/data/sources/local/local_auth.dart';
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
    required this.endAt,
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
  final DateTime endAt;
  @HiveField(10)
  final DateTime? cancelledAt;
  @HiveField(11)
  final DateTime createdAt;
  @HiveField(12)
  final DateTime updatedAt;
  @HiveField(13)
  final DateTime inHiveAt;
  @HiveField(99)
  final String notes;

  BookingEntity copyWith({
    String? businessID,
    String? serviceID,
    String? bookingID,
    String? customerID,
    String? employeeID,
    String? trackingID,
    StatusType? status,
    BookingPaymentDetailEntity? paymentDetail,
    DateTime? bookedAt,
    DateTime? endAt,
    DateTime? cancelledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return BookingEntity(
      businessID: businessID ?? this.businessID,
      serviceID: serviceID ?? this.serviceID,
      bookingID: bookingID ?? this.bookingID,
      customerID: customerID ?? this.customerID,
      employeeID: employeeID ?? this.employeeID,
      trackingID: trackingID ?? this.trackingID,
      status: status ?? this.status,
      paymentDetail:
          paymentDetail ?? this.paymentDetail as BookingPaymentDetailEntity,
      bookedAt: bookedAt ?? this.bookedAt,
      endAt: endAt ?? this.endAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  bool get amICustomer => customerID == LocalAuth.uid;
  bool get isCompleted =>
      status == StatusType.completed ||
      status == StatusType.cancelled ||
      status == StatusType.rejected;
}
