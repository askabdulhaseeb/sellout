import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/enums/core/status_type.dart';
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
      businessID: map['business_id'] ?? '',
      serviceID: map['service_id'] ?? '',
      bookingID: map['booking_id'] ?? '',
      customerID: map['book_by'] ?? '',
      employeeID: map['employee_id'] ?? '',
      trackingID: map['track_id'] ?? '',
      status: StatusType.fromJson(map['status']),
      paymentDetail: BookingPaymentDetailModel.fromMap(map['payment_detail']),
      bookedAt: (map['book_at']?.toString() ?? '').toDateTime(),
      endAt: (map['end_time']?.toString() ?? '').toDateTime(),
      cancelledAt: map['cancellation_time'] == null
          ? null
          : (map['cancellation_time']?.toString() ?? '').toDateTime(),
      createdAt: (map['created_at']?.toString() ?? '').toDateTime(),
      updatedAt: (map['updated_at']?.toString() ?? '').toDateTime(),
      notes: map['notes'] ?? '',
    );
  }
}

extension StringDateTimeExt on String {
  DateTime toDateTime() {
    try {
      // Handles "10:00 AM 2025-06-30"
      final format = DateFormat('hh:mm a yyyy-MM-dd');
      return format.parse(this).toLocal();
    } catch (_) {
      try {
        // Handles ISO format "2025-06-28T09:04:50.305Z"
        return DateTime.parse(this).toLocal();
      } catch (e) {
        return DateTime.now();
      }
    }
  }
}
