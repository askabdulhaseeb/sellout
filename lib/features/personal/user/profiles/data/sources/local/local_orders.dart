import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/utilities/app_string.dart';
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

  List<OrderEntity> getBySeller(String sellerId) {
    return _box.values.where((order) => order.sellerId == sellerId).toList();
  }

  Future<void> save(OrderEntity order) async {
    await _box.put(order.orderId, order); // assuming order.id is unique
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

  DataState<List<OrderEntity>> getState() {
    final List<OrderEntity> list = _box.values.toList();
    if (list.isNotEmpty) {
      return DataSuccess<List<OrderEntity>>('local', list);
    } else {
      return DataFailer<List<OrderEntity>>(CustomException('No local orders'));
    }
  }
}
