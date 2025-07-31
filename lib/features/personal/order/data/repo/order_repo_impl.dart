import '../../../../../../core/sources/data_state.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/params/get_order_params.dart';
import '../../domain/repo/order_repo.dart';
import '../models/order_model.dart';
import '../source/remote/order_by_user_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(
    this.orderByUserRemote,
  );

  final OrderByUserRemote orderByUserRemote;

  @override
  Future<DataState<List<OrderEntity>>> getOrderByUser(
      GetOrderParams? params) async {
    return await orderByUserRemote.getOrderByUser(params);
  }

  @override
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params) async {
    return await orderByUserRemote.getOrderByOrderId(params);
  }

  @override
  Future<DataState<bool>> createOrder(List<OrderModel> orderData) async {
    return await orderByUserRemote.createOrder(orderData);
  }

  @override
  Future<DataState<bool>> updateOrder(UpdateOrderParams params) async {
    return await orderByUserRemote.updateOrder(params);
  }
}
