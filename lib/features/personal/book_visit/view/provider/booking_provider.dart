import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/app_snakebar.dart';
import '../../../chats/chat/views/providers/chat_provider.dart';
import '../../../chats/chat/views/screens/chat_screen.dart';
import '../../../chats/chat_dashboard/data/models/chat/chat_model.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../chats/chat_dashboard/domain/usecase/get_my_chats_usecase.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../user/profiles/data/models/user_model.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../domain/usecase/book_service_usecase.dart';
import '../../domain/usecase/book_visit_usecase.dart';
import '../../domain/usecase/cancel_visit_usecase.dart';
import '../../domain/usecase/get_visit_by_post_usecase.dart';
import '../../domain/usecase/update_visit_usecase.dart';
import '../params/book_service_params.dart';
import '../params/book_visit_params.dart';
import '../params/update_visit_params.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider(
    this._bookVisitUseCase,
    this._updateVisitStatusUseCase,
    this._updateVisitUseCase,
    this._getmychatusecase,
    this._bookServiceUsecase,
    this._getUserByUidUsecase,
    this._getVisitByPostUsecase,
  );
  final BookVisitUseCase _bookVisitUseCase;
  final UpdateVisitStatusUseCase _updateVisitStatusUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final GetMyChatsUsecase _getmychatusecase;
  final BookServiceUsecase _bookServiceUsecase;
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetVisitByPostUsecase _getVisitByPostUsecase;

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
    List<VisitingEntity> visits,
  ) {
    try {
      final DateFormat timeFormat = DateFormat('hh:mm a');

      openingTime = openingTime.toUpperCase().trim();
      closingTime = closingTime.toUpperCase().trim();

      final DateTime openTime = parseTimeOnSelectedDate(openingTime);
      final DateTime closeTime = parseTimeOnSelectedDate(closingTime);

      final List<DateTime> bookedSlots = getBookedSlots(visits);
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

  DateTime parseTimeOnSelectedDate(String timeStr) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    final DateTime parsed = timeFormat.parse(timeStr, true);

    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      parsed.hour,
      parsed.minute,
    );
  }

  List<DateTime> getBookedSlots(List<VisitingEntity> visits) {
    final Map<String, VisitingEntity> latestAcceptedMap =
        <String, VisitingEntity>{};

    for (final VisitingEntity visit in visits) {
      final DateTime slotTime = DateTime(
        visit.dateTime.year,
        visit.dateTime.month,
        visit.dateTime.day,
        visit.dateTime.hour,
        visit.dateTime.minute,
      );

      if (!isSameDate(slotTime, _selectedDate)) continue;

      final String key = slotTime.toString();
      if (latestAcceptedMap.containsKey(key)) {
        final VisitingEntity existing = latestAcceptedMap[key]!;
        if (visit.createdAt!.isAfter(existing.createdAt!)) {
          latestAcceptedMap[key] = visit;
        }
      } else {
        latestAcceptedMap[key] = visit;
      }
    }

    return latestAcceptedMap.values.map((VisitingEntity visit) {
      // Use raw components without timezone conversion
      return DateTime(
        visit.dateTime.year,
        visit.dateTime.month,
        visit.dateTime.day,
        visit.dateTime.hour,
        visit.dateTime.minute,
      );
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

  Future<void> bookVisit(BuildContext context, String postID) async {
    isLoading = true;
    // setpostId(postID);
    // setbusinessId(businessID ?? 'null');
    final BookVisitParams params =
        BookVisitParams(dateTime: formattedDateTime, postId: postID);
    final DataState<VisitingEntity> result =
        await _bookVisitUseCase.call(params);
    if (result is DataSuccess) {
      final String chatId = result.data ?? '';
      DataState<List<ChatEntity>> chatresult =
          await _getmychatusecase.call(<String>[chatId]);
      if (chatresult is DataSuccess && (chatresult.data?.isNotEmpty ?? false)) {
        final ChatProvider chatProvider =
            Provider.of<ChatProvider>(context, listen: false);
        chatProvider.setChat(chatresult.entity!.first);
        Navigator.of(context).pushReplacementNamed(
          ChatScreen.routeName,
          arguments: chatId,
        );
      }
    } else if (result is DataFailer) {
      AppLog.error(
        result.exception?.message ?? 'ERROR - BookingProvider.BookVisit',
        name: 'BookingProvider.bookvisit - failed',
        error: result.exception,
      );
    }
    isLoading = false;
  }

  Future<void> updateVisitStatus({
    required BuildContext context,
    required String visitingId,
    required String messageId,
    required String chatID,
    required String status,
  }) async {
    isLoading = true;

    final UpdateVisitParams params = UpdateVisitParams(
      chatId: chatID,
      visitingId: visitingId.trim(),
      status: status,
      messageId: messageId.trim(),
      businessId: 'null',
    );
    debugPrint('${params.messageId},${params.visitingId} ');
    final DataState<VisitingEntity> result =
        await _updateVisitStatusUseCase(params);
    if (result is DataSuccess) {
      AppSnackBar.showSnackBar(context, 'visit_updated_successfully'.tr());
      Navigator.pop(context);
    } else {
      AppSnackBar.showSnackBar(
          context, result.exception?.message ?? 'something_wrong'.tr());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateVisit({
    required BuildContext context,
    required String visitingId,
    required String messageId,
    required String chatID,
  }) async {
    isLoading = true;

    final UpdateVisitParams params = UpdateVisitParams(
      chatId: chatID,
      visitingId: visitingId,
      datetime: formattedDateTime,
      messageId: messageId,
      businessId: 'null',
    );
    final DataState<VisitingEntity> result = await _updateVisitUseCase(params);
    if (result is DataSuccess) {
      AppSnackBar.showSnackBar(context, 'visit_updated'.tr());
      disposed();
      Navigator.pop(context);
    } else {
      AppSnackBar.showSnackBar(
          context, result.exception?.message ?? 'something_wrong'.tr());
    }
    isLoading = false;
  }

  Future<void> bookService(
    BuildContext context,
    String serviceId,
    String businessId,
  ) async {
    isLoading = true;
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
      isLoading = false;
      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        isLoading = false;
        print('Booking failed: ${result.exception}');
      }
    }
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

  void disposed() {
    _messageentity = null;
    _selectedDate = DateTime.now();
  }
}
