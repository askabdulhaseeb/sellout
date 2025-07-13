import 'package:flutter/foundation.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../order/domain/entities/order_entity.dart';
import '../../../../order/domain/usecase/get_orders_buyer_id.dart';

class PersonalSettingBuyerOrderProvider extends ChangeNotifier {
  PersonalSettingBuyerOrderProvider(
    this._buyerOrderUsecase,
  );
  final GetOrderByUidUsecase _buyerOrderUsecase;

  List<OrderEntity> _orders = <OrderEntity>[];
  List<OrderEntity> get orders => _orders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> getOrders() async {
    final String? uid = LocalAuth.uid;
    if (uid == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final DataState<List<OrderEntity>> result =
          await _buyerOrderUsecase.call(uid);

      if (result is DataSuccess) {
        _orders = result.entity ?? <OrderEntity>[];
      } else {
        _orders = <OrderEntity>[];
        _error = result.exception?.message ?? 'Unknown error';
      }
    } catch (e) {
      _orders = <OrderEntity>[];
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
