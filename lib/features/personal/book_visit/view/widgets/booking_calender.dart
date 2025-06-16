import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/enums/routine/day_type.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../business/core/data/models/routine_model.dart';
import '../../../../business/core/domain/entity/business_entity.dart';
import '../../../../business/core/domain/entity/routine_entity.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/data/models/meetup/availability_model.dart';
import '../../../post/domain/entities/meetup/availability_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../provider/booking_provider.dart';

class BookingCalendarWidget extends StatelessWidget {
  const BookingCalendarWidget({
    required this.post,
    super.key,
    this.visit,
    this.service,
    this.business,
  });
  final PostEntity? post;
  final VisitingEntity? visit;
  final ServiceEntity? service;
  final BusinessEntity? business;

  @override
  Widget build(BuildContext context) {
    final BookingProvider provider = Provider.of<BookingProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    // Determine selected day (in lowercase) from the provider's selected date.
    String selectedDay =
        DateFormat('EEEE').format(provider.selectedDate).toLowerCase();

    // Decide which data source to use based on whether post is available.
    final bool usePostAvailability = post != null;

    // Variables to hold the opening and closing times and open status.
    String? openingTime;
    String? closingTime;
    bool isOpen = false;

    if (usePostAvailability) {
      // Use post.availability if available.
      final List<AvailabilityEntity>? availabilities = post?.availability;
      final AvailabilityEntity selectedAvailability =
          availabilities?.firstWhere(
                (AvailabilityEntity entry) => entry.day.code == selectedDay,
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
      isOpen = selectedAvailability.isOpen;
      openingTime = selectedAvailability.openingTime;
      closingTime = selectedAvailability.closingTime;
    } else {
      // Otherwise, use business.routine, which is of type RoutineEntity.
      final List<RoutineEntity>? routines = business?.routine;
      final RoutineEntity selectedRoutine = routines?.firstWhere(
            (RoutineEntity entry) => entry.day.code == selectedDay,
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
      isOpen = selectedRoutine.isOpen;
      openingTime = selectedRoutine.opening;
      closingTime = selectedRoutine.closing;
    }

    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme
                      .primaryColor, // Set your desired indicator color here
                ),
          ),
          child: CalendarDatePicker(
            selectableDayPredicate: (DateTime date) {
              return date
                  .isAfter(DateTime.now().subtract(const Duration(days: 1)));
            },
            initialDate: visit?.dateTime ?? provider.selectedDate,
            firstDate: DateTime(2025),
            lastDate: DateTime(2100),
            onDateChanged: (DateTime newDate) {
              provider.updateDate(newDate);
            },
          ),
        ),
        const SizedBox(height: 20),
        if (isOpen &&
            openingTime != null &&
            closingTime != null &&
            openingTime.isNotEmpty &&
            closingTime.isNotEmpty)
          FutureBuilder<List<VisitingEntity>>(
            future: provider.getVisitsByPost(post?.postID ?? ''),
            builder: (BuildContext context,
                AsyncSnapshot<List<VisitingEntity>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('error_loading_slots'.tr());
              } else {
                final List<VisitingEntity> visits =
                    snapshot.data ?? <VisitingEntity>[];
                final List<Map<String, dynamic>> slots = provider
                    .generateTimeSlots(openingTime!, closingTime!, visits);
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            time,
                            style: textTheme.bodyMedium?.copyWith(
                              color: isBooked
                                  ? Colors.grey
                                  : (provider.selectedTime == time
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                              decoration:
                                  isBooked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          selected: provider.selectedTime == time,
                          onSelected: isBooked
                              ? null
                              : (bool selected) {
                                  provider.updateSelectedTime(
                                      selected ? time : null);
                                },
                          selectedColor: Theme.of(context).primaryColor,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          disabledColor: Colors.grey.shade300,
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        else
          Text(
            'closed_day'.tr(),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}
