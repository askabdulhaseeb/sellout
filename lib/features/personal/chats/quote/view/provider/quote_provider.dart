import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../../chat/views/providers/chat_provider.dart';
import '../../data/models/service_employee_model.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/params/get_service_slot_params.dart';
import '../../domain/params/hold_quote_pay_params.dart';
import '../../domain/params/request_quote_service_params.dart';
import '../../domain/params/update_quote_params.dart';
import '../../domain/usecases/get_service_slots_usecase.dart';
import '../../domain/usecases/hold_quote_pay_usecase.dart';
import '../../domain/usecases/release_payment_usecase.dart';
import '../../domain/usecases/request_quote_usecase.dart';
import '../../domain/usecases/update_quote_usecase.dart';

class QuoteProvider extends ChangeNotifier {
  QuoteProvider(
      this._requestQuoteUsecase,
      this._updateQuoteUsecase,
      this._holdQuotePayUsecase,
      this._getServiceSlotsUsecase,
      this._releaseQuotePayUsecase);
  final RequestQuoteUsecase _requestQuoteUsecase;
  final UpdateQuoteUsecase _updateQuoteUsecase;
  final GetServiceSlotsUsecase _getServiceSlotsUsecase;
  final HoldQuotePayUsecase _holdQuotePayUsecase;
  final ReleaseQuotePayUsecase _releaseQuotePayUsecase;

  final List<ServiceEmployeeModel> _selectedServices = <ServiceEmployeeModel>[];
  bool _isLoading = false;
  String? _errorMessage;
  List<SlotEntity> slots = <SlotEntity>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ServiceEmployeeModel> get selectedServices => _selectedServices;

  Future<void> fetchSlots({
    required String serviceId,
    required DateTime date,
    required String openingTime,
    required String closingTime,
    required int serviceDuration,
  }) async {
    _isLoading = true;
    notifyListeners();

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
    } else {
      slots = <SlotEntity>[];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSlots() {
    slots = <SlotEntity>[];
    notifyListeners();
  }

  /// Request a quote
  Future<bool> requestQuote(String businessId, context) async {
    _setLoading(true);
    RequestQuoteParams params = RequestQuoteParams(
        servicesAndEmployees: _selectedServices, businessId: businessId);
    debugPrint(params.toMap().toString());
    final DataState<bool> result = await _requestQuoteUsecase.call(params);
    _setLoading(false);

    if (result is DataSuccess<bool>) {
      Provider.of<ChatProvider>(context, listen: false)
          .createOrOpenChatById(context, result.data ?? '');

      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'something_wrong'.tr();
      notifyListeners();
      return false;
    }
  }

  /// Update a quote
  Future<bool> updateQuote(UpdateQuoteParams params) async {
    _setLoading(true);
    final DataState<bool> result = await _updateQuoteUsecase.call(params);
    _setLoading(false);
    if (result is DataSuccess<bool>) {
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'Update failed';
      notifyListeners();
      return false;
    }
  }

  /// Hold Quote payment
  Future<bool> holdQuotePay(HoldQuotePayParams params) async {
    _setLoading(true);
    final DataState<bool> result = await _holdQuotePayUsecase.call(params);
    _setLoading(false);
    if (result is DataSuccess<String>) {
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'hold pay failed';
      return false;
    }
  }

  Future<bool> releaseQuotePayUsecase(String transactionId) async {
    _setLoading(true);
    final DataState<String> result =
        await _releaseQuotePayUsecase.call(transactionId);
    _setLoading(false);
    if (result is DataSuccess<String>) {
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'realease pay failed';
      return false;
    }
  }

  void addService(ServiceEmployeeModel service) {
    _selectedServices.add(service);
    notifyListeners();
  }

  void clearServices() {
    _selectedServices.clear();
    notifyListeners();
  }

  void removeService(String serviceId) {
    _selectedServices.removeWhere(
        (ServiceEmployeeModel service) => service.serviceId == serviceId);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
