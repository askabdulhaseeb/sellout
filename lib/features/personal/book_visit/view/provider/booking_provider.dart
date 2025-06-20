import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../business/business_page/domain/params/get_business_bookings_params.dart';
import '../../../../business/business_page/domain/usecase/get_business_bookings_list_usecase.dart';
import '../../../bookings/domain/entity/booking_entity.dart';
import '../../../chats/chat/views/providers/chat_provider.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../user/profiles/data/models/user_model.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../domain/usecase/book_service_usecase.dart';
import '../../domain/usecase/book_visit_usecase.dart';
import '../../domain/usecase/get_visit_by_post_usecase.dart';
import '../../domain/usecase/update_visit_usecase.dart';
import '../params/book_service_params.dart';
import '../params/book_visit_params.dart';
import '../params/update_visit_params.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider(
      this._bookVisitUseCase,
      // this._updateVisitStatusUseCase,
      this._updateVisitUseCase,
      this._bookServiceUsecase,
      this._getUserByUidUsecase,
      this._getVisitByPostUsecase,
      this._getBookingsListUsecase);
  final BookVisitUseCase _bookVisitUseCase;
  // final UpdateVisitStatusUseCase _updateVisitStatusUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final BookServiceUsecase _bookServiceUsecase;
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetVisitByPostUsecase _getVisitByPostUsecase;
  final GetBookingsListUsecase _getBookingsListUsecase;
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

  List<Map<String, dynamic>> generateTimeSlots(
    String openingTime,
    String closingTime,
    List<dynamic> bookingsOrVisits,
    DateTime selectedDate,
  ) {
    try {
      final DateFormat timeFormat = DateFormat('hh:mm a');

      openingTime = openingTime.toUpperCase().trim();
      closingTime = closingTime.toUpperCase().trim();

      final DateTime openTime =
          parseTimeOnSelectedDate(openingTime, selectedDate);
      final DateTime closeTime =
          parseTimeOnSelectedDate(closingTime, selectedDate);

      final List<DateTime> bookedSlots =
          getBookedSlots(bookingsOrVisits, selectedDate);

      final List<Map<String, dynamic>> slots = <Map<String, dynamic>>[];
      DateTime current = openTime;

      while (
          current.isBefore(closeTime) || current.isAtSameMomentAs(closeTime)) {
        final String displaySlot = timeFormat.format(current);

        final bool isBooked = bookedSlots.any((DateTime booked) =>
            booked.year == current.year &&
            booked.month == current.month &&
            booked.day == current.day &&
            booked.hour == current.hour &&
            booked.minute == current.minute);

        slots.add(<String, dynamic>{
          'time': displaySlot,
          'isBooked': isBooked,
        });

        current = current.add(const Duration(minutes: 30));
      }

      return slots;
    } catch (e, stack) {
      AppLog.error(
        'Error: ${e.toString()}',
        name: 'BookingProvider.generateTimeSlots - catch',
      );
      debugPrint('Stack Trace: $stack');
      return <Map<String, dynamic>>[];
    }
  }

  DateTime parseTimeOnSelectedDate(String timeStr, DateTime selectedDate) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime parsed = timeFormat.parse(timeStr, true);

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      parsed.hour,
      parsed.minute,
    );
  }

  List<DateTime> getBookedSlots(List<dynamic> items, DateTime selectedDate) {
    final Map<String, dynamic> latestAcceptedMap = <String, dynamic>{};

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

      if (createdAt == null) continue;

      if (!isSameDate(slotTime, selectedDate)) continue;

      final String key = slotTime.toIso8601String();

      if (latestAcceptedMap.containsKey(key)) {
        final dynamic existing = latestAcceptedMap[key];
        final DateTime? existingCreatedAt = existing.createdAt;

        if (createdAt.isAfter(existingCreatedAt!)) {
          latestAcceptedMap[key] = item;
        }
      } else {
        latestAcceptedMap[key] = item;
      }
    }

    return latestAcceptedMap.values.map((dynamic item) {
      if (item is VisitingEntity) {
        return DateTime(
          item.dateTime.year,
          item.dateTime.month,
          item.dateTime.day,
          item.dateTime.hour,
          item.dateTime.minute,
        );
      } else if (item is BookingEntity) {
        return DateTime(
          item.bookedAt.year,
          item.bookedAt.month,
          item.bookedAt.day,
          item.bookedAt.hour,
          item.bookedAt.minute,
        );
      } else {
        return DateTime(1900); // fallback (won’t match anything)
      }
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
    final DataState<VisitingEntity> result =
        await _bookVisitUseCase.call(params);

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
    required String messageId,
    required String chatID,
    String? status,
  }) async {
    setIsLoading(true);

    final UpdateVisitParams params = UpdateVisitParams(
      query: query,
      chatId: chatID,
      visitingId: visitingId,
      datetime: formattedDateTime,
      messageId: messageId,
      status: status,
      businessId: 'null',
    );

    final DataState<VisitingEntity> result = await _updateVisitUseCase(params);

    if (result is DataSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('visit_updated'.tr()),
          duration: const Duration(seconds: 1),
        ),
      );
      disposed();
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.exception?.message ?? 'something_wrong'.tr()),
          duration: const Duration(seconds: 1),
        ),
      );
    }

    setIsLoading(false);
  }

  Future<void> bookService(
    BuildContext context,
    String serviceId,
    String businessId,
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
      businessId: businessId,
    );

    final DataState<VisitingEntity> result =
        await _bookServiceUsecase.call(params);

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

  Future<DataState<UserEntity?>> userbyuid(String uid) async {
    return await _getUserByUidUsecase.call(uid);
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

  void disposed() {
    _messageentity = null;
    _selectedDate = DateTime.now();
    _selectedTime = '';
  }
}
