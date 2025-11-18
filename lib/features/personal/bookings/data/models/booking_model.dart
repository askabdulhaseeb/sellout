import 'package:intl/intl.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../domain/entity/booking_entity.dart';
import 'booking_payment_detail_model.dart';

class BookingModel extends BookingEntity {
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      businessID: map['business_id'] ?? '',
      serviceID: map['service_id'] ?? '',
      bookingID: map['booking_id'] ?? '',
      customerID: map['book_by'] ?? '',
      employeeID: map['employee_id'] ?? '',
      trackingID: map['track_id'] ?? '',
      status: StatusType.fromJson(map['status']),
      paymentDetail: BookingPaymentDetailModel.fromMap(map['payment_detail']),
      bookedAt: _parseDate(map['book_at']),
      endAt: _parseDate(map['end_time']),
      cancelledAt: _parseDate(map['cancellation_time']),
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      notes: map['notes'] ?? '',
    );
  }
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

  /// Safe parser for handling both ISO8601 and custom formats
  static DateTime _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return DateTime.now();
    }
    final String str = value.toString();
    try {
      // Try ISO8601 first
      return DateTime.parse(str);
    } catch (_) {
      try {
        // Try your fallback format: "12:00 AM 2025-09-30"
        return DateFormat('hh:mm a yyyy-MM-dd').parse(str);
      } catch (_) {
        return DateTime.now();
      }
    }
  }
}
