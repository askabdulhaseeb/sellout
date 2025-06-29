import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/order_entity.dart';
export '../../models/order_model.dart';

class LocalOrders {
  static final String boxTitle = AppStrings.localOrdersBox;
  static Box<OrderEntity> get _box => Hive.box<OrderEntity>(boxTitle);
  static Future<Box<OrderEntity>> get openBox async =>
      await Hive.openBox<OrderEntity>(boxTitle);
  Future<Box<OrderEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<OrderEntity>(boxTitle);
    }
  }

  DataState<List<OrderEntity>> orderBySeller(String? value) {
    final String id = value ?? LocalAuth.uid ?? '';
    if (id.isEmpty) {
      return DataFailer<List<OrderEntity>>(
          CustomException('sellerId is empty'));
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

  Future<void> save(OrderEntity order) async {
    await _box.put(order.orderId, order);
  }

  Future<void> saveAll(List<OrderEntity> orders) async {
    final Map<String, OrderEntity> map = <String, OrderEntity>{
      for (OrderEntity order in orders) order.orderId: order
    };
    await _box.putAll(map);
  }

  Future<void> clear() async => await _box.clear();
  OrderEntity? get(String id) => _box.get(id);
  List<OrderEntity> getAll() => _box.values.toList();
}
