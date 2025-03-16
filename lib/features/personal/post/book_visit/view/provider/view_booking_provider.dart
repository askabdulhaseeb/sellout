import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../chats/chat/views/screens/chat_screen.dart';
import '../../domain/usecase/book_visit_usecase.dart';
import '../params/book_visit_params.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider(this._bookVisitUseCase);
  final BookVisitUseCase _bookVisitUseCase;

  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedpostId;
  String? _selectedbusinessId;

  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateDate(DateTime newDate) {
    _selectedDate = newDate;
    _selectedTime = null; // Reset time when date changes
    notifyListeners();
  }

  void updateSelectedTime(String? time) {
    _selectedTime = time;
    notifyListeners();
  }

  /// **Helper method to update loading state and notify listeners**
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setpostId(String postId) {
    _selectedpostId = postId;
    notifyListeners();
  }

  void setbusinessId(String postId) {
    _selectedbusinessId = postId;
    notifyListeners();
  }

  /// **Format selected date and time into: `hh:mm a yyyy-MM-dd`**
  String get formattedDateTime {
    if (_selectedTime == null) {
      return DateFormat('yyyy-MM-dd')
          .format(_selectedDate); // Only date if time is null
    }
    return '$_selectedTime ${DateFormat('yyyy-MM-dd').format(_selectedDate)}';
  }

  Future<void> bookVisit(BuildContext context) async {
    _setLoading(true);
    _errorMessage = null;
    final BookVisitParams params = BookVisitParams(
        businessId: _selectedbusinessId ?? 'null',
        dateTime: formattedDateTime,
        postId: _selectedpostId ?? '');
    debugPrint(params.toString());
    final DataState<bool> result = await _bookVisitUseCase.call(params);
    if (result is DataSuccess) {
      _errorMessage = null;
      Navigator.pushNamed(context, ChatScreen.routeName);
    } else if (result is DataFailer) {
      AppLog.error(
        result.exception?.message ?? 'ERROR - BookingProvider.BookVisit',
        name: 'BookingProvider.bookvisit - failed',
        error: result.exception,
      );
    }
    _setLoading(false);
  }
}
