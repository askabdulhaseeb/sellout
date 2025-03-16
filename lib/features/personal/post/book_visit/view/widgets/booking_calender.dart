import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/meetup/availability_entity.dart';
import '../provider/view_booking_provider.dart';

class BookingCalendarWidget extends StatelessWidget {
  const BookingCalendarWidget({required this.availabilities, super.key});
  final List<AvailabilityEntity>? availabilities;

  List<String> _generateTimeSlots(String openingTime, String closingTime) {
    try {
      final DateFormat format = DateFormat('hh:mm a');

      openingTime = openingTime.toUpperCase().trim();
      closingTime = closingTime.toUpperCase().trim();
      final DateTime open = format.parse(openingTime);
      final DateTime close = format.parse(closingTime);

      List<String> timeSlots = <String>[];
      DateTime current = open;

      while (current.isBefore(close) || current.isAtSameMomentAs(close)) {
        timeSlots.add(format.format(current));
        current = current.add(const Duration(minutes: 30));
      }

      return timeSlots;
    } catch (e) {
      debugPrint(
          "Time Parsing Error: $e (Opening: '$openingTime', Closing: '$closingTime')");
      return <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    final BookingProvider provider = Provider.of<BookingProvider>(context);
    String selectedDay =
        DateFormat('EEEE').format(provider.selectedDate).toLowerCase();

    final AvailabilityEntity? selectedAvailability = availabilities?.firstWhere(
      (AvailabilityEntity entry) => entry.day.code == selectedDay,
      orElse: () => const AvailabilityEntity(
        day: DayType.sunday,
        isOpen: false,
        openingTime: '',
        closingTime: '',
      ),
    );
    final TextTheme texttheme = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
          ),
          child: CalendarDatePicker(
            initialDate: provider.selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (DateTime newDate) {
              provider.updateDate(newDate);
            },
          ),
        ),
        const SizedBox(height: 20),
        if (selectedAvailability?.isOpen == true)
          SizedBox(
            height: 50, // Set a fixed height for horizontal scrolling
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Enables horizontal scrolling
              itemCount: _generateTimeSlots(
                selectedAvailability!.openingTime,
                selectedAvailability.closingTime,
              ).length,
              itemBuilder: (BuildContext context, int index) {
                String time = _generateTimeSlots(
                  selectedAvailability.openingTime,
                  selectedAvailability.closingTime,
                )[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(time),
                      selected: provider.selectedTime == time,
                      onSelected: (bool selected) {
                        provider.updateSelectedTime(selected ? time : null);
                      },
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                      labelStyle: texttheme.bodyMedium?.copyWith(
                          color: provider.selectedTime == time
                              ? Colors.white
                              : Colors.black)),
                );
              },
            ),
          )
        else
          Text('closed_day'.tr(),
              style: TextStyle(color: AppTheme.light.primaryColor)),
      ],
    );
  }
}
