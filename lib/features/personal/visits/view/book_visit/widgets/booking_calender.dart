import 'package:flutter/material.dart';
import '../../../../../../core/widgets/calender/create_booking_widgets/create_booking_calender.dart';
import '../../../../../../core/widgets/calender/create_booking_widgets/create_booking_slots.dart';
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
        CreateBookingCalender(
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
              return CreateBookingSlots(
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
