import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/sources/data_state.dart';
import '../../../../../core/utilities/app_string.dart';
import '../../domain/entity/booking_entity.dart';

class LocalBooking {
  static final String boxTitle = AppStrings.localBookingsBox;
  static Box<BookingEntity> get _box => Hive.box<BookingEntity>(boxTitle);

  static Future<Box<BookingEntity>> get openBox async =>
      await Hive.openBox<BookingEntity>(boxTitle);

  Future<Box<BookingEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<BookingEntity>(boxTitle);
    }
  }

  Future<void> save(BookingEntity user) async {
    await _box.put(user.bookingID, user);
  }

  // BookingEntity entity(String value) => _box.values.firstWhere(
  //       (BookingEntity element) => element.cartID == value,
  //       orElse: () => CartModel(),
  //     );

  DataState<BookingEntity?> state(String value) {
    final BookingEntity? entity = _box.get(value);
    if (entity != null) {
      return DataSuccess<BookingEntity?>(value, entity);
    } else {
      return DataFailer<BookingEntity?>(CustomException('Loading...'));
    }
  }

  List<BookingEntity> get all => _box.values.toList();
}
