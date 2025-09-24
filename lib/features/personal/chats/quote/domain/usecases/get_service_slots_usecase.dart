import 'package:intl/intl.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../../business/business_page/domain/repositories/business_page_services_repository.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../entites/time_slot_entity.dart';
import '../params/get_service_slot_params.dart';

class GetServiceSlotsUsecase
    implements UseCase<List<SlotEntity>, GetServiceSlotsParams> {
  GetServiceSlotsUsecase(this._repository);
  final BusinessPageRepository _repository;

  @override
  Future<DataState<List<SlotEntity>>> call(GetServiceSlotsParams params) async {
    try {
      // Fetch bookings from repository
      final DataState<List<BookingEntity>> bookingsResult =
          await _repository.getBookingsByServiceId(
        GetBookingsParams(serviceID: params.serviceId),
      );

      if (bookingsResult is DataSuccess && bookingsResult.data != null) {
        // Generate service slots using the SlotEntity
        final slots = ServiceSlotHelper.generateServiceSlots(
          bookings: bookingsResult.entity!,
          openingTime: params.openingTime,
          closingTime: params.closingTime,
          selectedDate: params.date,
          serviceDuration: params.serviceDuration,
        );
        return DataSuccess('Slots fetched successfully', slots);
      } else {
        return DataFailer(CustomException(bookingsResult.exception?.message ??
            'Unknown error fetching bookings'));
      }
    } catch (e) {
      return DataFailer(CustomException(e.toString()));
    }
  }
}

class ServiceSlotHelper {
  static List<SlotEntity> generateServiceSlots({
    required List<BookingEntity> bookings,
    required String openingTime,
    required String closingTime,
    required DateTime selectedDate,
    int serviceDuration = 30,
  }) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime open = _parseTimeOnSelectedDate(openingTime, selectedDate);
    final DateTime close = _parseTimeOnSelectedDate(closingTime, selectedDate);

    final List<SlotEntity> slotList = <SlotEntity>[];
    DateTime current = open;

    // Prepare booked ranges
    final List<Map<String, DateTime>> bookedRanges = bookings
        .where((BookingEntity b) =>
            b.bookedAt.year == selectedDate.year &&
            b.bookedAt.month == selectedDate.month &&
            b.bookedAt.day == selectedDate.day)
        .map((BookingEntity booking) {
      DateTime start = booking.bookedAt;
      DateTime end;
      try {
        end = booking.endAt;
      } catch (_) {
        end = start.add(Duration(minutes: serviceDuration));
      }
      return <String, DateTime>{'start': start, 'end': end};
    }).toList();

    // Generate slots
    while (current.add(Duration(minutes: serviceDuration)).isBefore(close) ||
        current
            .add(Duration(minutes: serviceDuration))
            .isAtSameMomentAs(close)) {
      final String displayTime = timeFormat.format(current);
      final DateTime slotStart = current;
      final DateTime slotEnd = current.add(Duration(minutes: serviceDuration));
      final bool isBooked = bookedRanges.any((Map<String, DateTime> range) {
        final DateTime start = range['start']!;
        final DateTime end = range['end']!;
        return slotStart.isBefore(end) && start.isBefore(slotEnd);
      });

      slotList.add(SlotEntity(
        time: displayTime,
        isBooked: isBooked,
        start: slotStart,
        end: slotEnd,
      ));

      current = slotEnd;
    }

    return slotList;
  }

  static DateTime _parseTimeOnSelectedDate(
      String timeStr, DateTime selectedDate) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    timeStr = timeStr.toLowerCase().replaceAll('.', '').trim();
    if (timeStr.endsWith('am')) timeStr = timeStr.replaceAll('am', 'AM');
    if (timeStr.endsWith('pm')) timeStr = timeStr.replaceAll('pm', 'PM');
    final DateTime parsed = timeFormat.parse(timeStr);
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      parsed.hour,
      parsed.minute,
    );
  }
}
