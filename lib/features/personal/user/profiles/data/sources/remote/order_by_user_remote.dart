import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/order_entity.dart';
import '../../models/order_model.dart';
import '../local/local_orders.dart';

abstract interface class OrderByUserRemote {
  Future<DataState<List<OrderEntity>>> getOrderByUser(String? userId);
  Future<DataState<bool>> createOrder(List<OrderModel> orderData);
}

class OrderByUserRemoteImpl implements OrderByUserRemote {
  @override
  Future<DataState<List<OrderEntity>>> getOrderByUser(String? userId) async {
    try {
      final String id = userId ?? LocalAuth.uid ?? '';
      if (id.isEmpty) {
        return DataFailer<List<OrderEntity>>(
          CustomException('userId is empty'),
        );
      }

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/orders/query?seller_id=$id',
        requestType: ApiRequestType.get,
        isAuth: true,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        final dynamic userable = json.decode(raw);
        final List<dynamic> list = userable['orders'];
        final List<OrderEntity> orders = <OrderEntity>[];

        for (dynamic element in list) {
          final OrderEntity order = OrderModel.fromJson(element);
          orders.add(order);
        }

        // 🧠 Save orders locally
        await LocalOrders().saveAll(orders);

        return DataSuccess<List<OrderEntity>>(raw, orders);
      } else {
        return DataFailer<List<OrderEntity>>(
          result.exception ?? CustomException('Failed to get post by user'),
        );
      }
    } catch (e, stc) {
      AppLog.error(
        e.toString(),
        name: 'PostByUserRemoteImpl.getOrderByUser - catch',
        error: e,
        stackTrace: stc,
      );
    }

    return DataFailer<List<OrderEntity>>(
      CustomException('Failed to get Order by user'),
    );
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
}
