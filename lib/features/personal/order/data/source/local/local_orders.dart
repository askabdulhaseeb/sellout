import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../core/utilities/app_string.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/usecase/get_order_by_order_id.dart';
export '../../models/order_model.dart';

class LocalOrders extends LocalHiveBox<OrderEntity> {
  @override
  String get boxName => AppStrings.localOrdersBox;

  /// Orders contain payment and transaction data - encrypt them.
  @override
  bool get requiresEncryption => true;

  Box<OrderEntity> get _box => box;

  /// Fetches order from local storage first, then from API if not found
  Future<OrderEntity?> fetchOrder(String orderId) async {
    debugPrint('🔍 Fetching order: $orderId');

    if (orderId.isEmpty) {
      debugPrint('   ❌ Order ID is empty');
      return null;
    }

    // Try local first
    final OrderEntity? localOrder = get(orderId);
    if (localOrder != null) {
      debugPrint('   ✅ Found in local storage');
      return localOrder;
    }

    debugPrint('   ! Not in local storage, fetching from API...');

    try {
      // Get the usecase from your DI container
      final GetOrderByOrderIdUsecase usecase =
          locator<GetOrderByOrderIdUsecase>();

      final DataState<List<OrderEntity>> result = await usecase.call(orderId);

      if (result is DataSuccess<List<OrderEntity>>) {
        final List<OrderEntity> orders = result.entity ?? <OrderEntity>[];
        if (orders.isNotEmpty) {
          debugPrint('   ✅ Fetched from API successfully');
          // Save to local storage
          await _box.put(orderId, orders.first);
          return orders.first;
        }
        debugPrint('   ❌ Failed to fetch order: No orders found in response');
      } else if (result is DataFailer<List<OrderEntity>>) {
        debugPrint(
          '   ❌ Failed to fetch order: ${result.exception?.message ?? "Unknown error"}',
        );
      }

      return null;
    } catch (e) {
      debugPrint('   ❌ Failed to fetch order - Exception: $e');
      return null;
    }
  }

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

  @override
  Future<void> clear() async => await _box.clear();
  @override
  OrderEntity? get(String id) => _box.get(id);
  @override
  List<OrderEntity> getAll() => _box.values.toList();
}
