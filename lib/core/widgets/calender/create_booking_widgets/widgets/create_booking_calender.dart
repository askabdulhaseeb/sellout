import 'package:flutter/material.dart';

class CreateBookingCalender extends StatelessWidget {
  const CreateBookingCalender({
    required this.initialDate,
    required this.onDateChanged,
    this.lastDate,
    super.key,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  /// Optional last date. Defaults to 5 years from now if not provided.
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    // Normalize dates to remove time components for consistent comparison
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Calculate safe first and last dates (date-only, no time component)
    final firstDate = today;
    final effectiveLastDate = lastDate != null

        ? DateTime(lastDate!.year, lastDate!.month, lastDate!.day)
        : DateTime(now.year + 5, now.month, now.day);

    // Ensure lastDate is not before firstDate

    final DateTime safeLastDate = effectiveLastDate.isBefore(firstDate)
        ? firstDate.add(const Duration(days: 365))
        : effectiveLastDate;

    // Normalize initial date to remove time component
    final normalizedInitialDate = DateTime(

      initialDate.year,
      initialDate.month,
      initialDate.day,
    );

    // Clamp initial date to be within valid range [firstDate, safeLastDate]
    final safeInitialDate = _clampDate(

      normalizedInitialDate,
      firstDate,
      safeLastDate,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: Theme.of(context).primaryColor),
      ),
      child: CalendarDatePicker(
        initialDate: safeInitialDate,
        firstDate: firstDate,
        lastDate: safeLastDate,
        selectableDayPredicate: (DateTime date) {
          // Normalize the date for comparison
          final DateTime normalizedDate = DateTime(date.year, date.month, date.day);

          // Allow selection of today and future dates within range
          return !normalizedDate.isBefore(firstDate) &&
              !normalizedDate.isAfter(safeLastDate);
        },
        onDateChanged: onDateChanged,
      ),
    );
  }

  /// Clamps the [date] to be within [minDate] and [maxDate] inclusive.
  DateTime _clampDate(DateTime date, DateTime minDate, DateTime maxDate) {
    if (date.isBefore(minDate)) {
      return minDate;
    } else if (date.isAfter(maxDate)) {
      return maxDate;
    }
    return date;
  }
}
