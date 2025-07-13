import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/data_state.dart';
import '../../data/source/local/local_orders.dart';
import '../../domain/entities/order_entity.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';
import '../../domain/usecase/update_order_usecase.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider(
    this._updateOrderUsecase,
  );
  final UpdateOrderUsecase _updateOrderUsecase;
  //
  OrderEntity? _order;

  OrderEntity? get order => _order;

  void loadOrder(String orderId) {
    _order = LocalOrders().get(orderId);
    notifyListeners();
  }

  void refreshOrder(String orderId) {
    _order = LocalOrders().get(orderId);
    notifyListeners();
  }

  //
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //
  Future<void> updateOrder(String orderId, String status) async {
    setLoading(true);
    final UpdateOrderParams params =
        UpdateOrderParams(orderId: orderId, status: status);
    final DataState<bool> result = await _updateOrderUsecase(params);
    if (result is DataSuccess) {
      AppLog.info('order_updated_successfully'.tr());
      loadOrder(orderId);
      setLoading(false);
    } else {
      AppLog.error(result.exception!.message,
          name: 'ProfileProvider.updateOrder - else');
      setLoading(false);
    }
  }
}
