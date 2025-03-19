import 'package:easy_localization/easy_localization.dart';
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
import '../../domain/usecase/book_visit_usecase.dart';
import '../../domain/usecase/cancel_visit_usecase.dart';
import '../../domain/usecase/update_visit_usecase.dart';
import '../params/book_visit_params.dart';
import '../params/update_visit_params.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider(this._bookVisitUseCase, this._cancelVisitUseCase,
      this._updateVisitUseCase, this._getmychatusecase);
  final BookVisitUseCase _bookVisitUseCase;
  final CancelVisitUseCase _cancelVisitUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final GetMyChatsUsecase _getmychatusecase;

  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _isLoading = false;
  String? _selectedpostId;
  String? _selectedbusinessId;
  MessageEntity? _messageentity;

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

  void setpostId(String postId) {
    _selectedpostId = postId;
    notifyListeners();
  }

  void setbusinessId(String postId) {
    _selectedbusinessId = postId;
    notifyListeners();
  }

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
      debugPrint(
          "Time Parsing Error: $e (Opening: '$openingTime', Closing: '$closingTime')");
      return <String>[];
    }
  }

  Future<void> bookVisit(BuildContext context) async {
    isLoading = true;
    final BookVisitParams params = BookVisitParams(
        businessId: _selectedbusinessId ?? 'null',
        dateTime: formattedDateTime,
        postId: _selectedpostId ?? '');
    final DataState<VisitingEntity> result =
        await _bookVisitUseCase.call(params);
    if (result is DataSuccess) {
      final String chatId = result.data ?? '';
      DataState<List<ChatEntity>> chatresult =
          await _getmychatusecase.call(<String>[chatId]);
      if (chatresult is DataSuccess && (chatresult.data?.isNotEmpty ?? false)) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.chat = chatresult.entity!.first;
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
  }) async {
    isLoading = true;

    final UpdateVisitParams params = UpdateVisitParams(
      visitingId: visitingId,
      status: 'cancel',
      messageId: messageId,
      businessId: 'null',
    );

    final DataState<VisitingEntity> result = await _cancelVisitUseCase(params);
    if (result is DataSuccess) {
      AppSnackBar.showSnackBar(context, 'visit_cancelled'.tr());
      Navigator.pop(context);
    } else {
      AppSnackBar.showSnackBar(
          context, result.exception?.message ?? 'something_wrong'.tr());
    }
    isLoading = false;
  }

  Future<void> updateVisit({
    required BuildContext context,
    required String visitingId,
    required String messageId,
  }) async {
    isLoading = true;

    final UpdateVisitParams params = UpdateVisitParams(
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

  void disposed() {
    _messageentity = null;
    _selectedDate = DateTime.now();
  }
}
