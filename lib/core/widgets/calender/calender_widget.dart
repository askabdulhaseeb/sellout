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

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      controller: _controller,
      view: CalendarView.day,
      headerHeight: 0,
      showTodayButton: false,
      viewHeaderHeight: 0,
      dataSource: BookingDataSource(widget.bookings),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 0,
        endHour: 24,
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
