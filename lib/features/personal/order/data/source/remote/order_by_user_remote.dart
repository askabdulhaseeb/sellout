import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../user/profiles/domain/params/update_order_params.dart';
import '../../../domain/params/get_order_params.dart';
import '../local/local_orders.dart';

abstract interface class OrderByUserRemote {
  Future<DataState<List<OrderEntity>>> getOrderByQuery(GetOrderParams? userId);
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params);
  Future<DataState<bool>> createOrder(List<OrderModel> orderData);
  Future<DataState<bool>> updateOrder(UpdateOrderParams params);
}

class OrderByUserRemoteImpl implements OrderByUserRemote {
  @override
  Future<DataState<List<OrderEntity>>> getOrderByQuery(
      GetOrderParams? params) async {
    final String endpoint = params?.endpoint ?? '';
    if (endpoint.isEmpty) {
      return DataFailer<List<OrderEntity>>(
        CustomException('invalid_endpoint'),
      );
    }

    try {
      final ApiRequestEntity? local = await LocalRequestHistory().request(
        endpoint: endpoint,
        duration: const Duration(days: 1),
      );
      if (local != null) {
        final dynamic parsed = json.decode(local.encodedData);
        final List<dynamic> ordersJson = parsed['orders'] ?? <dynamic>[];
        final List<OrderEntity> orders = ordersJson
            .where((dynamic e) => e != null)
            .map<OrderEntity>(
                (dynamic e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();

        await LocalOrders().saveAll(orders);
        return DataSuccess<List<OrderEntity>>(local.encodedData, orders);
      }
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
      );

      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        final dynamic parsed = json.decode(raw);
        final List<dynamic> ordersJson = parsed['orders'] ?? <dynamic>[];
        final List<OrderEntity> orders = ordersJson
            .where((dynamic e) => e != null)
            .map<OrderEntity>(
                (dynamic e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // save fresh response to cache
        await LocalRequestHistory().save(
          ApiRequestEntity(url: endpoint, encodedData: raw),
        );

        await LocalOrders().saveAll(orders);
        return DataSuccess<List<OrderEntity>>(raw, orders);
      } else {
        return DataFailer<List<OrderEntity>>(
          result.exception ?? CustomException('failed_to_get_orders'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OrderByUserRemoteImpl.getOrderByUser - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<List<OrderEntity>>(
        CustomException('failed_to_get_order_by_user'),
      );
    }
  }

  @override
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params) async {
    try {
      final String endpoint = '/orders/${params}';
      // 🌐 Always hit network
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
      );
      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        final dynamic parsed = json.decode(raw);
        final List<dynamic> ordersJson = parsed['orders'] ?? <dynamic>[];
        final List<OrderEntity> orders = ordersJson
            .where((dynamic e) => e != null)
            .map<OrderEntity>(
                (dynamic e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        // 🔄 Optional: still save locally
        await LocalOrders().save(orders.first);

        return DataSuccess<List<OrderEntity>>(raw, orders);
      } else {
        return DataFailer<List<OrderEntity>>(
          result.exception ?? CustomException('Failed to get orders'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OrderByUserRemoteImpl.getOrderByUser - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<List<OrderEntity>>(
        CustomException('Failed to get Order by user'),
      );
    }
  }

  @override
  Future<DataState<bool>> createOrder(List<OrderModel> orderData) async {
    try {
      final List<Map<String, dynamic>> jsonOrders =
          orderData.map((OrderModel e) => e.toJson()).toList();

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/orders/create',
        requestType: ApiRequestType.post,
        body: json.encode(jsonOrders),
        isAuth: true,
      );
      AppLog.info('ceate order data ${result.data ?? ''}');
      if (result is DataSuccess) {
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        return DataFailer<bool>(
          result.exception ?? CustomException('Failed to create order'),
        );
      }
    } catch (e, stc) {
      AppLog.error(e.toString(),
          name: 'PostByUserRemoteImpl.createOrder - catch',
          error: e,
          stackTrace: stc);
      return DataFailer<bool>(
        CustomException('Failed to create order'),
      );
    }
  }

  @override
  Future<DataState<bool>> updateOrder(UpdateOrderParams params) async {
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/orders/update/status',
        requestType: ApiRequestType.patch,
        body: jsonEncode(params.toMap()),
        isAuth: true,
      );
      AppLog.info('order updated: ${result.data ?? ''}');
      if (result is DataSuccess) {
        // 🟢 Get existing order from local Hive
        final OrderEntity? order = LocalOrders().get(params.orderId);

        if (order != null) {
          // 🟢 Create updated copy with new status
          final OrderEntity updatedOrder = order.copyWith(
            orderStatus: params.status,
          );

          await LocalOrders().save(updatedOrder);
        }

        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'something_wrong',
          name: 'PostByUserRemoteImpl.updateOrder - else',
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('Failed to update order'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'PostByUserRemoteImpl.updateOrder - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(
        CustomException('Failed to update order'),
      );
    }
  }
}
