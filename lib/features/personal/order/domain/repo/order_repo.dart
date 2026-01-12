import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';
import '../../data/models/return_eligibility_model.dart';
import '../entities/order_entity.dart';
import '../params/get_order_params.dart';
import '../params/order_return_params.dart';
import '../params/return_eligibility_params.dart';

abstract interface class OrderRepository {
  Future<DataState<List<OrderEntity>>> getOrderByUser(GetOrderParams? uid);
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params);
  Future<DataState<bool>> updateOrder(UpdateOrderParams params);
  Future<DataState<ReturnEligibilityModel>> checkReturnEligibility(
    ReturnEligibilityParams params,
  );
  Future<DataState<bool>> orderReturn(OrderReturnParams params);
}
