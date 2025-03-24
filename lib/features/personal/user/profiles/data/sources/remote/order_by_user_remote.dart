import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/orderentity.dart';
import '../../models/order_model.dart';

abstract interface class OrderByUserRemote {
  Future<DataState<List<OrderEntity>>> getOrderByUser(String? userId);
}

class OrderByUserRemoteImpl implements OrderByUserRemote {
  @override
  Future<DataState<List<OrderEntity>>> getOrderByUser(String? userId) async {
    try {
      //
      final String id = userId ?? LocalAuth.uid ?? '';
      if (id.isEmpty) {
        return DataFailer<List<OrderEntity>>(
            CustomException('userId is empty'));
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
        final List<OrderEntity> posts = <OrderEntity>[];
        for (dynamic element in list) {
          final OrderEntity post = OrderModel.fromJson(element);
          posts.add(post);
        }
        return DataSuccess<List<OrderEntity>>(raw, posts);
      } else {
        return DataFailer<List<OrderEntity>>(
          result.exception ?? CustomException('Failed to get post by user'),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostByUserRemoteImpl.getOrderByUser - catch',
        error: e,
      );
    }
    return DataFailer<List<OrderEntity>>(
      CustomException('Failed to get Order by user'),
    );
  }
}
