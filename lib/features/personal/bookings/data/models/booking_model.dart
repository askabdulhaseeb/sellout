import '../../../../../core/enums/core/status_type.dart';
import '../../../../../core/extension/string_ext.dart';
import '../../domain/entity/booking_entity.dart';
import 'booking_payment_detail_model.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.businessID,
    required super.serviceID,
    required super.bookingID,
    required super.customerID,
    required super.employeeID,
    required super.trackingID,
    required super.status,
    required super.paymentDetail,
    required super.bookedAt,
    required super.endAt,
    required super.cancelledAt,
    required super.createdAt,
    required super.updatedAt,
    required super.notes,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      businessID: map['business_id'],
      serviceID: map['service_id'],
      bookingID: map['booking_id'],
      customerID: map['book_by'],
      employeeID: map['employee_id'],
      trackingID: map['track_id'],
      status: StatusType.fromJson(map['status']),
      paymentDetail: BookingPaymentDetailModel.fromMap(map['payment_detail']),
      bookedAt: map['book_at']?.toString().toDateTime() ?? DateTime.now(),
      endAt: map['end_time']?.toString().toDateTime() ?? DateTime.now(),
      cancelledAt: map['cancellation_time'] == null
          ? null
          : map['cancellation_time']?.toString().toDateTime() ?? DateTime.now(),
      createdAt: map['created_at']?.toString().toDateTime() ?? DateTime.now(),
      updatedAt: map['updated_at']?.toString().toDateTime() ?? DateTime.now(),
      notes: map['notes'] ?? '',
    );
  }
}
