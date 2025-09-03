import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/enums/routine/day_type.dart';
import '../../../../../business/core/data/models/routine_model.dart';
import '../../../../post/data/models/meetup/availability_model.dart';
import '../../../../../business/core/domain/entity/routine_entity.dart';
import '../../../../post/domain/entities/meetup/availability_entity.dart';
import '../provider/booking_provider.dart';

class BookingCalendarWidget extends StatelessWidget {
  const BookingCalendarWidget({
    this.post,
    super.key,
    this.visit,
    this.service,
    this.business,
    this.booking,
  });

  final PostEntity? post;
  final VisitingEntity? visit;
  final ServiceEntity? service;
  final BusinessEntity? business;
  final BookingEntity? booking;

  @override
  Widget build(BuildContext context) {
    final BookingProvider provider = Provider.of<BookingProvider>(context);
    final String selectedDay =
        DateFormat('EEEE').format(provider.selectedDate).toLowerCase();

    final bool usePostAvailability = post != null;
    String? openingTime;
    String? closingTime;
    bool isOpen = false;

    if (usePostAvailability) {
      final AvailabilityEntity availability = post?.availability?.firstWhere(
            (AvailabilityEntity e) => e.day.code == selectedDay,
            orElse: () => AvailabilityModel(
              day: DayType.sunday,
              isOpen: false,
              openingTime: '',
              closingTime: '',
            ),
          ) ??
          AvailabilityModel(
            day: DayType.sunday,
            isOpen: false,
            openingTime: '',
            closingTime: '',
          );
      isOpen = availability.isOpen;
      openingTime = availability.openingTime;
      closingTime = availability.closingTime;
    } else {
      final RoutineEntity routine = business?.routine?.firstWhere(
            (RoutineEntity e) => e.day.code == selectedDay,
            orElse: () => RoutineModel(
              day: DayType.sunday,
              isOpen: false,
              opening: '',
              closing: '',
            ),
          ) ??
          RoutineModel(
            day: DayType.sunday,
            isOpen: false,
            opening: '',
            closing: '',
          );
      isOpen = routine.isOpen;
      openingTime = routine.opening;
      closingTime = routine.closing;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        BookingDatePickerWidget(
          initialDate: visit?.dateTime ?? provider.selectedDate,
          onDateChanged: provider.updateDate,
        ),
        const SizedBox(height: 20),
        if (!isOpen || openingTime == null || closingTime == null)
          Text(
            'closed_day'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )
        else
          FutureBuilder<List<Map<String, dynamic>>>(
            future: provider.getFinalSlotList(
              openingTime: openingTime,
              closingTime: closingTime,
              selectedDate: provider.selectedDate,
              postId: post?.postID,
              serviceId: service?.serviceID,
              serviceDuration: 30,
            ),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('error_loading_slots'.tr());
              }

              final List<Map<String, dynamic>> slots =
                  snapshot.data ?? <Map<String, dynamic>>[];

              return BookingSlotSelectorWidget(
                slots: slots,
                selectedTime: provider.selectedTime,
                onSlotSelected: provider.updateSelectedTime,
              );
            },
          ),
      ],
    );
  }
}

class BookingDatePickerWidget extends StatelessWidget {
  const BookingDatePickerWidget({
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
              primary: AppTheme.primaryColor,
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

class BookingSlotSelectorWidget extends StatelessWidget {
  const BookingSlotSelectorWidget({
    required this.slots,
    required this.selectedTime,
    required this.onSlotSelected,
    super.key,
  });

  final List<Map<String, dynamic>> slots;
  final String? selectedTime;
  final ValueChanged<String?> onSlotSelected;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (slots.isEmpty) {
      return Text('no_available_slots'.tr());
    }

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: slots.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> slot = slots[index];
          final String time = slot['time'] as String;
          final bool isBooked = slot['isBooked'] as bool;

          final bool isSelected = selectedTime == time;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(
                time,
                style: textTheme.bodyMedium?.copyWith(
                  color: isBooked
                      ? Theme.of(context)
                          .colorScheme
                          .error
                          .withValues(alpha: 0.6) // light red
                      : (isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface),
                  decoration: isBooked ? TextDecoration.lineThrough : null,
                ),
              ),
              selected: isSelected,
              onSelected: isBooked
                  ? null
                  : (bool selected) {
                      onSlotSelected(selected ? time : null);
                    },
              selectedColor: AppTheme.primaryColor,
              backgroundColor: isBooked
                  ? Theme.of(context).disabledColor.withValues(alpha: 0.2)
                  : Theme.of(context).colorScheme.surface,
              disabledColor:
                  Theme.of(context).disabledColor.withValues(alpha: 0.2),
              elevation: 0,
            ),
          );
        },
      ),
    );
  }
}
