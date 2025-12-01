import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../core/enums/core/status_type.dart';
import '../../../../../core/extension/string_ext.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../domain/entity/booking_entity.dart';

class LocalBooking extends LocalHiveBox<BookingEntity> {
  @override
  String get boxName =>  AppStrings.localBookingsBox;
  
  Box<BookingEntity> get _box => box;

  Future<void> update(String bookingId, Map<String, dynamic> metadata) async {
    final BookingEntity? existing = _box.get(bookingId);

    if (existing != null) {
      final BookingEntity updated = existing.copyWith(
        serviceID: metadata['service_id'] ?? existing.serviceID,
        employeeID: metadata['employee_id'] ?? existing.employeeID,
        businessID: metadata['business_id'] ?? existing.businessID,
        bookedAt: (metadata['book_at']?.toString() ?? '')
            .toDateTime(), // use your extension
        status: StatusType.fromJson(metadata['status']),
        updatedAt: DateTime.now(),
      );

      await _box.put(bookingId, updated);
      debugPrint('booking updated');
    }
  }

  DataState<BookingEntity?> state(String value) {
    final BookingEntity? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<BookingEntity?>(value, entity);
    } else {
      return DataFailer<BookingEntity?>(CustomException('Loading...'));
    }
  }

  List<BookingEntity> get all => _box.values.toList();

  List<BookingEntity> userBooking(String value) {
    return _box.values
        .where((BookingEntity element) => element.customerID == value)
        .toList();
  }
}
