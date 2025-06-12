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
import '../../domain/usecase/update_visit_usecase.dart';
import '../params/book_service_params.dart';
import '../params/book_visit_params.dart';
import '../params/update_visit_params.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider(
      this._bookVisitUseCase,
      this._cancelVisitUseCase,
      this._updateVisitUseCase,
      this._getmychatusecase,
      this._bookServiceUsecase,
      this._getUserByUidUsecase);
  final BookVisitUseCase _bookVisitUseCase;
  final CancelVisitUseCase _cancelVisitUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final GetMyChatsUsecase _getmychatusecase;
  final BookServiceUsecase _bookServiceUsecase;
  final GetUserByUidUsecase _getUserByUidUsecase;

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

  List<String> generateTimeSlots(String openingTime, String closingTime) {
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
      AppLog.error(e.toString(),
          name: 'BookingProvider.generateTimeSlots -catch');
      return <String>[];
    }
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

  Future<void> cancelVisit({
    required BuildContext context,
    required String visitingId,
    required String messageId,
    required String chatID,
  }) async {
    isLoading = true;

    final UpdateVisitParams params = UpdateVisitParams(
      chatId: chatID,
      visitingId: visitingId.trim(),
      status: 'cancel',
      messageId: messageId.trim(),
      businessId: 'null',
    );
    debugPrint('${params.messageId},${params.visitingId} ');
    final DataState<VisitingEntity> result = await _cancelVisitUseCase(params);
    if (result is DataSuccess) {
      AppSnackBar.showSnackBar(context, 'visit_cancelled'.tr());
      Navigator.pop(context);
    } else {
      AppSnackBar.showSnackBar(
          context, result.exception?.message ?? 'something_wrong'.tr());
    }
    isLoading = false;
    // notifyListeners();
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

  Future<DataState<UserEntity?>> userbyuid(String uid) async {
    return await _getUserByUidUsecase.call(uid);
  }

  void disposed() {
    _messageentity = null;
    _selectedDate = DateTime.now();
  }
}
