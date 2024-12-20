import '../../../../../core/enums/core/status_type.dart';
import '../../../../../core/extension/string_ext.dart';
import '../../domain/entity/booking_payment_detail_entity.dart';

class BookingPaymentDetailModel extends BookingPaymentDetailEntity {
  BookingPaymentDetailModel({
    required super.transactionID,
    required super.status,
    required super.updatedAt,
    required super.createdAt,
  });

  factory BookingPaymentDetailModel.fromMap(Map<String, dynamic> map) {
    return BookingPaymentDetailModel(
      transactionID: map['transaction_id'] != null
          ? map['transaction_id'] as String
          : null,
      status: map['status'] != null ? StatusType.fromJson(map['status']) : null,
      updatedAt: map['updated_at'] != null
          ? map['updated_at']?.toString().toDateTime() ?? DateTime.now()
          : null,
      createdAt: map['created_at'] != null
          ? map['created_at']?.toString().toDateTime() ?? DateTime.now()
          : null,
    );
  }
}
