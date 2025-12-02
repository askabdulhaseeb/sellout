import 'package:flutter/material.dart';
import '../../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../post/domain/entities/meetup/availability_entity.dart';

class AvailabilityManager extends ChangeNotifier {
  List<AvailabilityEntity> _availability = DayType.values.map((DayType day) {
    return AvailabilityEntity(
      day: day,
      isOpen: false,
      openingTime: '',
      closingTime: '',
    );
  }).toList();
  List<AvailabilityEntity> get availability => _availability;
  void setAvailabilty(List<AvailabilityEntity> val) {
    // Build a map for fast lookup
    final Map<DayType, AvailabilityEntity> inputMap = <DayType, AvailabilityEntity>{
      for (final AvailabilityEntity entity in val) entity.day: entity
    };
    _availability = DayType.values.map((DayType day) {
      return inputMap[day] ??
          AvailabilityEntity(
            day: day,
            isOpen: false,
            openingTime: '',
            closingTime: '',
          );
    }).toList();
    notifyListeners();
  }

  void toggleOpen(DayType day, bool isOpen) {
    try {
      final int index =
          _availability.indexWhere((AvailabilityEntity e) => e.day == day);

      if (index != -1) {
        final AvailabilityEntity current = _availability[index];

        _availability[index] = current.copyWith(
          isOpen: isOpen,
          openingTime: isOpen ? '10:00 am' : '',
          closingTime: isOpen ? '10:00 pm' : '',
        );

        // 🟢 Log before notifying listeners
        AppLog.info(
          name: 'Availability Updated',
          'Day: ${day.name}, Open: $isOpen, '
          'OpeningTime: ${_availability[index].openingTime}, '
          'ClosingTime: ${_availability[index].closingTime}',
        );
      } else {
        // ⚠️ Log if day not found
        AppLog.error('Day not found in availability list: ${day.name}');
      }
    } catch (e, stack) {
      // 🔴 Log unexpected errors
      AppLog.error('toggleOpen() failed for ${day.name}',
          error: e, stackTrace: stack);
    }
  }

  void setOpeningTime(DayType day, String time) {
    final int index =
        _availability.indexWhere((AvailabilityEntity e) => e.day == day);
    if (index != -1) {
      final AvailabilityEntity current = _availability[index];
      _availability[index] = current.copyWith(openingTime: time);

      // Log the change
      AppLog.info(
        name: 'Opening Time Updated',
        'Day: ${day.name}, New Time: $time',
      );

      notifyListeners();
    }
  }

  void setClosingTime(DayType day, String time) {
    final int index =
        _availability.indexWhere((AvailabilityEntity e) => e.day == day);
    if (index != -1) {
      final AvailabilityEntity current = _availability[index];
      _availability[index] = current.copyWith(closingTime: time);

      // Log the change
      AppLog.info(
        name: 'Closing Time Updated',
        'Day: ${day.name}, New Time: $time',
      );

      notifyListeners();
    }
  }

  List<String> generateTimeSlots() {
    final List<String> slots = <String>[];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
        slots.add(_formatTimeOfDay(time));
      }
    }
    return slots;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final int hourOfPeriod = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hourOfPeriod:$minute $period';
  }

  TimeOfDay parseTimeString(String timeString) {
    try {
      final List<String> parts = timeString.split(RegExp(r'[: ]'));
      final int hour = int.parse(parts[0]) +
          ((parts[2].toLowerCase() == 'pm' && parts[0] != '12') ? 12 : 0);
      final int minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  bool isClosingTimeValid(String openingTime, String closingTime) {
    final TimeOfDay open = parseTimeString(openingTime);
    final TimeOfDay close = parseTimeString(closingTime);
    return ((close.hour * 60 + close.minute) > (open.hour * 60 + open.minute));
  }

  void updateOpeningTime(DayType day, String time) {
    setOpeningTime(day, time);
    final AvailabilityEntity entity =
        availability.firstWhere((AvailabilityEntity e) => e.day == day);
    if (entity.closingTime.isEmpty ||
        !isClosingTimeValid(time, entity.closingTime)) {
      final TimeOfDay parsedTime = parseTimeString(time);
      final TimeOfDay endTime =
          parsedTime.replacing(hour: (parsedTime.hour + 1) % 24);
      setClosingTime(day, _formatTimeOfDay(endTime));
    }
  }

  List<Map<String, dynamic>> getAvailabilityData() {
    final List<Map<String, dynamic>> jsonArray = _availability
        .where((AvailabilityEntity entity) => entity.isOpen)
        .map((AvailabilityEntity entity) => <String, dynamic>{
              'day': entity.day.name,
              'is_open': entity.isOpen,
              'opening_time': entity.openingTime,
              'closing_time': entity.closingTime,
            })
        .toList();

    return jsonArray;
  }

  void reset() {
    try {
      // Reset availability list to default state
      _availability = DayType.values.map((DayType day) {
        return AvailabilityEntity(
          day: day,
          isOpen: false,
          openingTime: '',
          closingTime: '',
        );
      }).toList();

      // Log the reset operation
      AppLog.info(
        name: 'Availability Reset',
        'Reset completed: ${_availability.length} days initialized to default state',
      );

      // Notify listeners of the change
      notifyListeners();
    } catch (e, stack) {
      // Log any errors during reset
      AppLog.error(
        'Failed to reset availability',
        error: e,
        stackTrace: stack,
      );
      rethrow; // Rethrow to allow error handling by caller
    }
  }
}
