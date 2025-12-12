import 'package:flutter/widgets.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../../user/profiles/domain/params/update_order_params.dart';
import '../../../domain/params/get_order_params.dart';
import '../local/local_orders.dart';
import '../../../domain/params/return_eligibility_params.dart';
import '../../../domain/params/order_return_params.dart';
import '../../models/return_eligibility_model.dart';

abstract interface class OrderByUserRemote {
  Future<DataState<List<OrderEntity>>> getOrderByQuery(GetOrderParams? userId);
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params);
  Future<DataState<bool>> updateOrder(UpdateOrderParams params);
  Future<DataState<ReturnEligibilityModel>> checkReturnEligibility(
    ReturnEligibilityParams params
  );
  Future<DataState<bool>> orderReturn(OrderReturnParams params);
}

class OrderByUserRemoteImpl implements OrderByUserRemote {
  @override
  Future<DataState<List<OrderEntity>>> getOrderByQuery(
    GetOrderParams? params,
  ) async {
    final String endpoint = params?.endpoint ?? '';
    if (endpoint.isEmpty) {
      return DataFailer<List<OrderEntity>>(CustomException('invalid_endpoint'));
    }
    try {
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
              (dynamic e) => OrderModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        // Save all fetched orders locally
        for (final OrderEntity order in orders) {
          await LocalOrders().save(order.orderId, order);
        }
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
      final String endpoint = '/orders/$params';
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
              (dynamic e) => OrderModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        // 🔄 Optional: still save locally
        await LocalOrders().save(orders.first.orderId, orders.first);

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

          await LocalOrders().save(updatedOrder.orderId, updatedOrder);
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
      return DataFailer<bool>(CustomException('Failed to update order'));
    }
  }

  @override
  Future<DataState<ReturnEligibilityModel>> checkReturnEligibility(
    ReturnEligibilityParams params,
  ) async {
    try {
      final String endpoint = '/orders/return/eligibility/${params.orderId}';
      final Map<String, dynamic> body = <String, dynamic>{
        'order_id': params.orderId,
        'object_id': params.objectId,
      };
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: jsonEncode(body),
        isAuth: true,
      );
      debugPrint('Return eligibility raw response: ${result.data}');

      if (result is DataSuccess<String>) {
        final String raw = result.data ?? '';
        final ReturnEligibilityModel? model = ReturnEligibilityModel.fromRaw(
          raw,
        );
        return DataSuccess<ReturnEligibilityModel>(raw, model);
      } else {
        return DataFailer<ReturnEligibilityModel>(
          result.exception ?? CustomException('failed_to_check_return'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OrderByUserRemoteImpl.checkReturnEligibility - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<ReturnEligibilityModel>(
        CustomException('failed_to_check_return'),
      );
    }
  }

  @override
  Future<DataState<bool>> orderReturn(OrderReturnParams params) async {
    // legacy: keep parity with checkReturnEligibility; consider simplifying
    try {
      final String endpoint = '/orders/return/requestpost';
      final Map<String, dynamic> body = <String, dynamic>{
        'order_id': params.orderId,
        'reason': params.reason,
        if (params.objectId != null) 'object_id': params.objectId,
      };
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: jsonEncode(body),
        isAuth: true,
      );
      debugPrint(
        'Order return response: ${result is DataSuccess ? result.data : result}',
      );

      if (result is DataSuccess<bool>) {
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        return DataFailer<bool>(
          result.exception ?? CustomException('failed_to_request_return'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'OrderByUserRemoteImpl.orderReturn - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException('failed_to_request_return'));
    }
  }
}
