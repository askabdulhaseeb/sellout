import 'package:flutter/foundation.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../domain/params/request_quote_service_params.dart';
import '../../domain/params/update_quote_params.dart';
import '../../domain/usecases/request_quote_usecase.dart';
import '../../domain/usecases/update_quote_usecase.dart';

/// A single provider class for both Request Quote and Update Quote
class QuoteProvider extends ChangeNotifier {
  QuoteProvider(this._requestQuoteUsecase, this._updateQuoteUsecase);
  final RequestQuoteUsecase _requestQuoteUsecase;
  final UpdateQuoteUsecase _updateQuoteUsecase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Request a quote
  Future<bool> requestQuote(RequestQuoteParams params) async {
    _setLoading(true);
    final DataState<bool> result = await _requestQuoteUsecase.call(params);
    _setLoading(false);

    if (result is DataSuccess<bool>) {
      return true;
    } else {
      _errorMessage = result.exception?.message ?? 'Request failed';
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
