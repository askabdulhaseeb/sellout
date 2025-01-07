import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../features/personal/bookings/domain/entity/booking_entity.dart';
import '../../../features/business/core/domain/entity/business_entity.dart';
import '../../../features/business/business_page/domain/entities/booking_data_source.dart';
import 'calender_booking_tile.dart';

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({
    required this.business,
    required this.bookings,
    super.key,
  });
  final BusinessEntity business;
  final List<BookingEntity> bookings;

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  final CalendarController _controller = CalendarController();
  double startingHour() {
    try {
      return widget.bookings.where((BookingEntity booking) {
        return booking.bookedAt.day == DateTime.now().day &&
            booking.bookedAt.month == DateTime.now().month &&
            booking.bookedAt.year == DateTime.now().year;
      }).map<double>((BookingEntity booking) {
        return booking.bookedAt.hour.toDouble();
      }).reduce((double a, double b) => a < b ? a : b);
    } catch (e) {
      return 0;
    }
  }

  double endingHour() {
    try {
      return widget.bookings.where((BookingEntity booking) {
        return booking.bookedAt.day == DateTime.now().day &&
            booking.bookedAt.month == DateTime.now().month &&
            booking.bookedAt.year == DateTime.now().year;
      }).map<double>((BookingEntity booking) {
        return booking.bookedAt.hour.toDouble();
      }).reduce((double a, double b) => a > b ? a : b);
    } catch (e) {
      return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      controller: _controller,
      view: CalendarView.day,
      headerHeight: 0,
      showTodayButton: false,
      viewHeaderHeight: 0,
      dataSource: BookingDataSource(widget.bookings),
      timeSlotViewSettings: TimeSlotViewSettings(
        startHour: startingHour(),
        endHour: endingHour(),
        timeIntervalHeight: 100,
      ),
      appointmentBuilder: (
        BuildContext context,
        CalendarAppointmentDetails detail,
      ) {
        final BookingEntity booking = detail.appointments.first;
        return CalenderBookingTile(booking: booking);
      },
    );
  }
}
