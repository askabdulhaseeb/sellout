import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../../chat/views/providers/chat_provider.dart';
import '../../domain/entites/service_employee_entity.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/params/get_service_slot_params.dart';
import '../../domain/params/hold_quote_pay_params.dart';
import '../../domain/params/request_quote_service_params.dart';
import '../../domain/params/update_quote_params.dart';
import '../../domain/usecases/get_service_slots_usecase.dart';
import '../../domain/usecases/hold_quote_pay_usecase.dart';
import '../../domain/usecases/request_quote_usecase.dart';
import '../../domain/usecases/update_quote_usecase.dart';
import '../screens/pages/step_booking.dart';

class QuoteProvider extends ChangeNotifier {
  QuoteProvider(
    this._requestQuoteUsecase,
    this._updateQuoteUsecase,
    this._holdQuotePayUsecase,
    this._getServiceSlotsUsecase,
  );

  // Dependencies
  final RequestQuoteUsecase _requestQuoteUsecase;
  final UpdateQuoteUsecase _updateQuoteUsecase;
  final HoldQuotePayUsecase _holdQuotePayUsecase;
  final GetServiceSlotsUsecase _getServiceSlotsUsecase;
  String? _globalBookAt;
  // Controllers & state
  final TextEditingController note = TextEditingController();
  final List<ServiceEmployeeEntity> _selectedServices =
      <ServiceEmployeeEntity>[];
  bool _isLoading = false;
  String? _errorMessage;
  List<SlotEntity> slots = <SlotEntity>[];
  AppointmentTimeSelection _appointmentTimeType =
      AppointmentTimeSelection.differentTimePerService;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ServiceEmployeeEntity> get selectedServices =>
      List.unmodifiable(_selectedServices);
  AppointmentTimeSelection get appointmentTimeType => _appointmentTimeType;
  String? get globalBookAt => _globalBookAt;

  // ---------------------- 🔹 FETCH SLOTS ----------------------
  Future<void> fetchSlots({
    required String serviceId,
    required DateTime date,
    required String openingTime,
    required String closingTime,
    required int serviceDuration,
  }) async {
    _setLoading(true);

    final DataState<List<SlotEntity>> result =
        await _getServiceSlotsUsecase.call(
      GetServiceSlotsParams(
        serviceId: serviceId,
        date: date,
        openingTime: openingTime,
        closingTime: closingTime,
        serviceDuration: serviceDuration,
      ),
    );

    if (result is DataSuccess<List<SlotEntity>>) {
      slots = result.entity ?? <SlotEntity>[];
      _errorMessage = null;
    } else {
      slots = <SlotEntity>[];
      _errorMessage = result.exception?.message ?? 'something_wrong'.tr();
    }

    _setLoading(false);
  }

  void clearSlots() {
    slots = <SlotEntity>[];
    notifyListeners();
  }

  // ---------------------- 🔹 QUOTE ACTIONS ----------------------
  Future<bool> requestQuote(String businessId, BuildContext context) async {
    _setLoading(true);

    final RequestQuoteParams params = RequestQuoteParams(
      note: note.text,
      servicesAndEmployees: _selectedServices,
      businessId: businessId,
    );

    final DataState<bool> result = await _requestQuoteUsecase.call(params);
    _setLoading(false);

    if (result is DataSuccess<bool>) {
      // Open chat after successful quote request
      Provider.of<ChatProvider>(context, listen: false)
          .createOrOpenChatById(context, result.data ?? '');
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'something_wrong'.tr();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateQuote(UpdateQuoteParams params) async {
    _setLoading(true);
    final DataState<bool> result = await _updateQuoteUsecase.call(params);
    _setLoading(false);

    if (result is DataSuccess<bool>) {
      _errorMessage = null;
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'Update failed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> holdQuotePay(HoldQuotePayParams params) async {
    _setLoading(true);
    final DataState<bool> result = await _holdQuotePayUsecase.call(params);
    _setLoading(false);

    if (result is DataSuccess<String>) {
      _errorMessage = null;
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'hold pay failed';
      notifyListeners();
      return false;
    }
  }

  // ---------------------- 🔹 SERVICES HANDLING ----------------------

  void addService(ServiceEmployeeEntity service) {
    final int index = _selectedServices.indexWhere(
      (ServiceEmployeeEntity s) => s.serviceId == service.serviceId,
    );

    if (index != -1) {
      _selectedServices[index] = _selectedServices[index].copyWith(
        quantity: _selectedServices[index].quantity + 1,
      );
    } else {
      _selectedServices.add(service.copyWith(quantity: 1));
    }
    notifyListeners();
  }

  void removeService(String serviceId) {
    final int index = _selectedServices.indexWhere(
      (ServiceEmployeeEntity s) => s.serviceId == serviceId,
    );

    if (index == -1) return;

    final ServiceEmployeeEntity existing = _selectedServices[index];
    if (existing.quantity > 1) {
      _selectedServices[index] = existing.copyWith(
        quantity: existing.quantity - 1,
      );
    } else {
      _selectedServices.removeAt(index);
    }

    notifyListeners();
  }

  void clearServices() {
    _selectedServices.clear();
    notifyListeners();
  }

  void updateService(ServiceEmployeeEntity updated) {
    final int index = _selectedServices.indexWhere(
      (ServiceEmployeeEntity s) => s.serviceId == updated.serviceId,
    );
    if (index != -1) {
      _selectedServices[index] = updated;
    } else {
      _selectedServices.add(updated);
    }
    notifyListeners();
  }

  // ---------------------- 🔹 STATE HELPERS ----------------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAppointmentTimeType(AppointmentTimeSelection value) {
    _appointmentTimeType = value;
    notifyListeners();
  }

  // ---------------------- 🔹 RESET EVERYTHING ----------------------
  void reset() {
    note.clear();
    _selectedServices.clear();
    slots.clear();
    _errorMessage = null;
    _isLoading = false;
    _appointmentTimeType = AppointmentTimeSelection.differentTimePerService;
    notifyListeners();
  }

  void setGlobalBookAt(String time) {
    _globalBookAt = time;

    // also update all service entities with this global time
    for (final ServiceEmployeeEntity s in selectedServices) {
      s.bookAt = time;
    }
    notifyListeners();
  }

  void setServiceTime(String serviceId, String bookAt) {
    final int index = _selectedServices.indexWhere(
      (ServiceEmployeeEntity s) => s.serviceId == serviceId,
    );

    if (index != -1) {
      _selectedServices[index] =
          _selectedServices[index].copyWith(bookAt: bookAt);

      if (_appointmentTimeType == AppointmentTimeSelection.oneTimeForAll) {
        _globalBookAt = bookAt;
        for (int i = 0; i < _selectedServices.length; i++) {
          _selectedServices[i] =
              _selectedServices[i].copyWith(bookAt: _globalBookAt!);
        }
      }
    }

    notifyListeners();
  }
}
