import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../core/enums/routine/day_type.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../post/data/models/meetup/availability_model.dart';
import '../../../post/domain/entities/meetup/availability_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../provider/view_booking_provider.dart';

class BookingCalendarWidget extends StatelessWidget {
  const BookingCalendarWidget({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    final List<AvailabilityEntity>? availabilities = post.availability;
    final BookingProvider provider = Provider.of<BookingProvider>(context);
    String selectedDay =
        DateFormat('EEEE').format(provider.selectedDate).toLowerCase();
    final AvailabilityEntity? selectedAvailability = availabilities?.firstWhere(
        (AvailabilityEntity entry) => entry.day.code == selectedDay,
        orElse: (() => AvailabilityModel(
              day: DayType.sunday,
              isOpen: false,
              openingTime: '',
              closingTime: '',
            )));
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
            selectableDayPredicate: (DateTime date) {
              return date
                  .isAfter(DateTime.now().subtract(const Duration(days: 1)));
            },
            initialDate:
            provider.selectedDate,
            firstDate: DateTime(2025),
            lastDate: DateTime(2100),
            onDateChanged: (DateTime newDate) {
              provider.updateDate(newDate);
            },
          ),
        ),
        const SizedBox(height: 20),
        if (selectedAvailability?.isOpen == true)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider
                  .generateTimeSlots(
                    selectedAvailability!.openingTime,
                    selectedAvailability.closingTime,
                  )
                  .length,
              itemBuilder: (BuildContext context, int index) {
                String time = provider.generateTimeSlots(
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
