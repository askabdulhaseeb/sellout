import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../../business/business_page/domain/usecase/get_bookings_by_service_id_usecase.dart';
import '../../../../appointment/domain/params/update_appointment_params.dart';
import '../../../../appointment/domain/usecase/update_appointment_usecase.dart';
import '../../../../bookings/domain/entity/booking_entity.dart';
import '../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../../user/profiles/data/models/user_model.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../../domain/usecase/book_service_usecase.dart';
import '../../../domain/usecase/book_visit_usecase.dart';
import '../../../domain/usecase/get_visit_by_post_usecase.dart';
import '../../../domain/usecase/update_visit_usecase.dart';
import '../params/book_service_params.dart';
import '../params/book_visit_params.dart';
import '../params/update_visit_params.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider(
      this._bookVisitUseCase,
      this._updateVisitUseCase,
      this._bookServiceUsecase,
      this._getUserByUidUsecase,
      this._getVisitByPostUsecase,
      this._getBookingsListUsecase,
      this._updateAppointmentUsecase);
  final BookVisitUseCase _bookVisitUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final BookServiceUsecase _bookServiceUsecase;
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetVisitByPostUsecase _getVisitByPostUsecase;
  final GetBookingsByServiceIdListUsecase _getBookingsListUsecase;
  final UpdateAppointmentUsecase _updateAppointmentUsecase;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _isLoading = false;
  // String? _selectedpostId;
  // String? _selectedbusinessId;
  MessageEntity? _messageentity;
  List<UserEntity> employees = <UserEntity>[];
  UserEntity? selectedEmployee;
  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  bool get isLoading => _isLoading;
  MessageEntity? get messageentity => _messageentity;

  void updateDate(DateTime newDate) {
    _selectedDate = newDate;
    _selectedTime = null;
    notifyListeners();
  }

  void updateSelectedTime(String? time) {
    _selectedTime = time;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessageEntity(MessageEntity messagenetity) {
    _messageentity = messagenetity;
  }
  // void _setChatId(String chatId) {
  //   _chatId = chatId;
  //   notifyListeners();
  // }

  // void setpostId(String postId) {
  //   _selectedpostId = postId;
  //   notifyListeners();
  // }

  // void setbusinessId(String postId) {
  //   _selectedbusinessId = postId;
  //   notifyListeners();
  // }

  String get formattedDateTime {
    if (_selectedTime == null) {
      return DateFormat('yyyy-MM-dd').format(_selectedDate);
    }
    return '$_selectedTime ${DateFormat('yyyy-MM-dd').format(_selectedDate)}';
  }

  Future<List<Map<String, dynamic>>> getFinalSlotList({
    required String openingTime,
    required String closingTime,
    required DateTime selectedDate,
    required String? postId,
    required String? serviceId,
    int serviceDuration = 30,
  }) async {
    try {
      final DateFormat timeFormat = DateFormat('hh:mm a');
      final DateTime open = parseTimeOnSelectedDate(openingTime, selectedDate);
      final DateTime close = parseTimeOnSelectedDate(closingTime, selectedDate);

      final List<Map<String, dynamic>> slotList = <Map<String, dynamic>>[];

      DateTime current = open;

      if (serviceId != null && serviceId.isNotEmpty) {
        // 🟢 Booking slot logic
        final List<Map<String, DateTime>> bookedRanges =
            await getBookedBookingSlots(
          serviceId: serviceId,
          selectedDate: selectedDate,
        );

        while (
            current.add(Duration(minutes: serviceDuration)).isBefore(close) ||
                current
                    .add(Duration(minutes: serviceDuration))
                    .isAtSameMomentAs(close)) {
          final String displayTime = timeFormat.format(current);
          final bool isBlocked =
              bookedRanges.any((Map<String, DateTime> range) {
            final DateTime start = range['start']!;
            final DateTime end = range['end']!;
            return current.isBefore(end) &&
                start.isBefore(current.add(Duration(minutes: serviceDuration)));
          });

          slotList.add(<String, dynamic>{
            'time': displayTime,
            'isBooked': isBlocked,
          });

          current = current.add(const Duration(minutes: 30));
        }
      } else if (postId != null && postId.isNotEmpty) {
        // 🟡 Visiting slot logic
        final List<DateTime> visitTimes = await getBookedVisitSlots(
          postId: postId,
          selectedDate: selectedDate,
        );

        while (current.isBefore(close) || current.isAtSameMomentAs(close)) {
          final String displayTime = timeFormat.format(current);

          final bool isBooked = visitTimes.any((DateTime visit) =>
              visit.year == current.year &&
              visit.month == current.month &&
              visit.day == current.day &&
              visit.hour == current.hour &&
              visit.minute == current.minute);

          slotList.add(<String, dynamic>{
            'time': displayTime,
            'isBooked': isBooked,
          });

          current = current.add(const Duration(minutes: 30));
        }
      }

      return slotList;
    } catch (e, stack) {
      debugPrint('❌ Error in getFinalSlotList: $e');
      debugPrint(stack.toString());
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Map<String, DateTime>>> getBookedBookingSlots({
    required String serviceId,
    required DateTime selectedDate,
  }) async {
    final List<BookingEntity> bookings = await getBookingBYServiceID(serviceId);

    final List<Map<String, DateTime>> booked = <Map<String, DateTime>>[];

    for (final BookingEntity booking in bookings) {
      if (!isSameDate(booking.bookedAt, selectedDate)) continue;

      DateTime start = booking.bookedAt;
      DateTime end;
      try {
        end = booking.endAt;
      } catch (_) {
        end = start.add(const Duration(minutes: 30));
      }

      booked.add(<String, DateTime>{'start': start, 'end': end});
    }

    return booked;
  }

  Future<List<DateTime>> getBookedVisitSlots({
    required String postId,
    required DateTime selectedDate,
  }) async {
    final List<VisitingEntity> visits = await getVisitsByPost(postId);

    return visits
        .where((VisitingEntity v) => isSameDate(v.dateTime, selectedDate))
        .map((VisitingEntity v) => v.dateTime)
        .toList();
  }

  DateTime parseTimeOnSelectedDate(String timeStr, DateTime selectedDate) {
    final DateFormat timeFormat = DateFormat('hh:mm a');

    // 👇 Clean the input: remove dots, extra spaces, force uppercase
    timeStr = timeStr
        .toLowerCase()
        .replaceAll('.', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // 👇 Capitalize 'am' / 'pm' properly
    if (timeStr.endsWith('am')) {
      timeStr = timeStr.replaceAll('am', 'AM');
    } else if (timeStr.endsWith('pm')) {
      timeStr = timeStr.replaceAll('pm', 'PM');
    }

    final DateTime parsed = timeFormat.parse(timeStr);

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      parsed.hour,
      parsed.minute,
    );
  }

  Future<List<DateTime>> getBookedSlots({
    required String? serviceId,
    required String? postId,
    required DateTime selectedDate,
  }) async {
    final Map<String, dynamic> latestAcceptedMap = <String, dynamic>{};

    List<dynamic> items = <dynamic>[];

    // 🔹 1. Fetch data inside this method
    if (serviceId != null && serviceId.isNotEmpty) {
      items = await getBookingBYServiceID(serviceId);
    } else if (postId != null && postId.isNotEmpty) {
      items = await getVisitsByPost(postId);
    }

    // 🔹 2. Extract latest slot per time
    for (final dynamic item in items) {
      DateTime? slotTime;
      DateTime? createdAt;

      if (item is VisitingEntity) {
        slotTime = item.dateTime;
        createdAt = item.createdAt;
      } else if (item is BookingEntity) {
        slotTime = item.bookedAt;
        createdAt = item.createdAt;
      } else {
        continue;
      }

      if (createdAt == null || !isSameDate(slotTime, selectedDate)) continue;

      final String key = slotTime.toIso8601String();

      if (!latestAcceptedMap.containsKey(key) ||
          createdAt.isAfter(latestAcceptedMap[key].createdAt)) {
        latestAcceptedMap[key] = item;
      }
    }

    return latestAcceptedMap.values.map((dynamic item) {
      if (item is VisitingEntity) return item.dateTime;
      if (item is BookingEntity) return item.bookedAt;
      return DateTime(1900);
    }).toList();
  }

  bool isSameDate(DateTime a, DateTime b) {
    final bool same = a.year == b.year && a.month == b.month && a.day == b.day;
    debugPrint('Compare Dates: $a vs $b => isSame: $same');
    return same;
  }

  Future<void> fetchEmployees(List<String> employeesID) async {
    employees.clear();
    for (String id in employeesID) {
      final DataState<UserEntity?> user = await userbyuid(id);
      employees.add(user.entity!);
    }
    if (employees.isNotEmpty) {
      selectedEmployee = employees.first;
    }
    notifyListeners();
  }

  void setSelectedEmployee(UserEntity? user) {
    selectedEmployee = user;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> bookVisit(BuildContext context, String postID) async {
    setIsLoading(true);
    final BookVisitParams params =
        BookVisitParams(dateTime: formattedDateTime, postId: postID);
    final DataState<bool> result = await _bookVisitUseCase.call(params);
    if (result is DataSuccess) {
      final String chatId = result.data ?? '';
      await Provider.of<ChatProvider>(context, listen: false)
          .createOrOpenChatById(context, chatId);
    } else if (result is DataFailer) {
      AppLog.error(
        result.exception?.message ?? 'ERROR - BookingProvider.BookVisit',
        name: 'BookingProvider.bookvisit - failed',
        error: result.exception,
      );
    }
    setIsLoading(false);
  }

  Future<void> updateVisit({
    required String query,
    required BuildContext context,
    required String visitingId,
    String? messageId,
    String? chatID,
    String? status,
  }) async {
    setIsLoading(true);

    final UpdateVisitParams params = UpdateVisitParams(
      query: query,
      chatId: chatID ?? '',
      visitingId: visitingId,
      datetime: formattedDateTime,
      messageId: messageId ?? '',
      status: status,
      businessId: 'null',
    );

    final DataState<VisitingEntity> result = await _updateVisitUseCase(params);
    if (result is DataSuccess) {
      // ignore: use_build_context_synchronously

      notifyListeners();
    } else {}
    setIsLoading(false);
  }

  Future<void> bookService(
    BuildContext context,
    String serviceId,
  ) async {
    setIsLoading(true);

    final BookServiceParams params = BookServiceParams(
      servicesAndEmployees: <ServiceAndEmployee>[
        ServiceAndEmployee(
          serviceId: serviceId,
          employeeId: selectedEmployee!.uid,
          bookAt: formattedDateTime,
        ),
      ],
    );
    final DataState<bool> result = await _bookServiceUsecase.call(params);
    if (result is DataSuccess) {
      if (kDebugMode) {
        print('Booking successful: ${result.data}');
      }
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print('Booking failed: ${result.exception}');
      }
    }
    setIsLoading(false);
  }

  Future<void> updateServiceBooking(
      BuildContext context, BookingEntity? booking) async {
    try {
      final UpdateAppointmentParams params = UpdateAppointmentParams(
        apiKey: 'booking_time',
        bookingID: booking?.bookingID ?? '',
        bookAt: formattedDateTime,
      );
      final DataState<bool> result =
          await _updateAppointmentUsecase.call(params);
      if (result is DataSuccess) {
        Navigator.pop(context);
      } else {
        AppLog.error('',
            error: result.exception?.message ?? 'something_wrong',
            name: 'BookingProvider.updateServiceBooking - else');
      }
    } catch (e, stack) {
      debugPrint('Exception during updateServiceBooking: $e');
      AppLog.error('',
          error: e,
          stackTrace: stack,
          name: 'BookingProvider.updateServiceBooking - catch');
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<DataState<UserEntity?>> userbyuid(String uid) async {
    return await _getUserByUidUsecase.call(uid);
  }

  Future<List<VisitingEntity>> getVisitsByPost(String postId) async {
    debugPrint('🔍 Fetching visits for postId: $postId');
    final DataState<List<VisitingEntity>> result =
        await _getVisitByPostUsecase.call(postId);
    if (result is DataSuccess && result.data != null) {
      debugPrint(
          '✅ Successfully fetched visits: ${result.entity!.length} visits found');
      for (final VisitingEntity visit in result.entity!) {
        debugPrint('📌 Visit: ${visit.dateTime}');
      }

      return result.entity!;
    } else {
      final String errorMsg =
          result.exception?.message ?? 'Unknown error in GetVisitByPostUsecase';
      debugPrint('❌ Failed to fetch visits: $errorMsg');
      AppLog.error(
        errorMsg,
        name: 'BookingProvider.getVisitsByPost',
        error: result.exception,
      );
      return <VisitingEntity>[];
    }
  }

  Future<List<BookingEntity>> getBookingBYServiceID(String serviceID) async {
    debugPrint('🔍 Fetching Bookings for ServiceID: $serviceID');
    final GetBookingsParams params = GetBookingsParams(serviceID: serviceID);
    final DataState<List<BookingEntity>> result =
        await _getBookingsListUsecase.call(params);

    if (result is DataSuccess && result.data != null) {
      debugPrint(
          '✅ Successfully fetched services: ${result.entity!.length} services found');
      for (final BookingEntity booking in result.entity!) {
        debugPrint('📌 Visit: ${booking.bookedAt}');
      }
      return result.entity!;
    } else {
      final String errorMsg = result.exception?.message ??
          'Unknown error in getBookingBYServiceID ';
      debugPrint('❌ Failed to fetch visits: $errorMsg');
      AppLog.error(
        errorMsg,
        name: 'BookingProvider.getBookingBYServiceID',
        error: result.exception,
      );

      return <BookingEntity>[];
    }
  }

  void reset() {
    _messageentity = null;
    _selectedDate = DateTime.now();
    _selectedTime = null;
    _isLoading = false;
    selectedEmployee = null;
    employees.clear();
    notifyListeners();
  }
}
