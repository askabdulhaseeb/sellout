import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';
import '../../data/models/order_model.dart';
import '../entities/order_entity.dart';
import '../params/get_order_params.dart';

abstract interface class OrderRepository {
  Future<DataState<List<OrderEntity>>> getOrderByUser(GetOrderParams? uid);
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params);
  Future<DataState<bool>> createOrder(List<OrderModel> orderData);
  Future<DataState<bool>> updateOrder(UpdateOrderParams params);
}
