import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/order_entity.dart';
export '../../models/order_model.dart';

class LocalOrders extends LocalHiveBox<OrderEntity> {
  @override
  String get boxName => AppStrings.localOrdersBox;

  /// Orders contain payment and transaction data - encrypt them.
  @override
  bool get requiresEncryption => true;

  Box<OrderEntity> get _box => box;

  DataState<List<OrderEntity>> orderBySeller(String? value) {
    final String id = value ?? LocalAuth.uid ?? '';
    if (id.isEmpty) {
      return DataFailer<List<OrderEntity>>(
        CustomException('sellerId is empty'),
      );
    }
    final List<OrderEntity> orders = _box.values.where((OrderEntity order) {
      return order.sellerId == id;
    }).toList();
    if (orders.isEmpty) {
      return DataFailer<List<OrderEntity>>(CustomException('No orders found'));
    } else {
      return DataSuccess<List<OrderEntity>>('', orders);
    }
  }

  Future<void> saveAllOrders(List<OrderEntity> orders) async {
    final Map<String, OrderEntity> map = <String, OrderEntity>{
      for (OrderEntity order in orders) order.orderId: order,
    };
    await _box.putAll(map);
  }

  Future<void> clear() async => await _box.clear();
  OrderEntity? get(String id) => _box.get(id);
  List<OrderEntity> getAll() => _box.values.toList();
}
