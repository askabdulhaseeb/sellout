import 'package:flutter/material.dart';

class CreateBookingCalender extends StatelessWidget {
  const CreateBookingCalender({
    required this.initialDate,
    required this.onDateChanged,
    super.key,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).primaryColor,
            ),
      ),
      child: CalendarDatePicker(
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        selectableDayPredicate: (DateTime date) =>
            date.isAfter(DateTime.now().subtract(const Duration(days: 1))),
        onDateChanged: onDateChanged,
      ),
    );
  }
}
