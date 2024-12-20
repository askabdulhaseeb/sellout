import 'dart:ui';
import 'dart:math';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../personal/bookings/domain/entity/booking_entity.dart';

class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<BookingEntity> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as BookingEntity).bookedAt;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as BookingEntity)
        .bookedAt
        .add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as BookingEntity).customerID;
  }

  @override
  Color getColor(int index) {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  String? getNotes(int index) {
    return (appointments![index] as BookingEntity).notes;
  }

  // @override
  // String? getLocation(int index) {
  //   return (appointments![index] as BookingEntity).location;
  // }

  String? getEmployeeID(int index) {
    return (appointments![index] as BookingEntity).employeeID;
  }

  String? getBookingID(int index) {
    return (appointments![index] as BookingEntity).bookingID;
  }

  String? getServiceID(int index) {
    return (appointments![index] as BookingEntity).serviceID;
  }

  String? getBusinessID(int index) {
    return (appointments![index] as BookingEntity).businessID;
  }

  String? getCustomerID(int index) {
    return (appointments![index] as BookingEntity).customerID;
  }

  String? getTrackingID(int index) {
    return (appointments![index] as BookingEntity).trackingID;
  }
}
