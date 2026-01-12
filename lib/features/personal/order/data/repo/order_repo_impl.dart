import '../../../../../../core/sources/data_state.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/params/get_order_params.dart';
import '../../domain/params/order_return_params.dart';
import '../../domain/params/return_eligibility_params.dart';
import '../../domain/repo/order_repo.dart';
import '../models/return_eligibility_model.dart';
import '../source/remote/order_by_user_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.orderByUserRemote);

  final OrderByUserRemote orderByUserRemote;

  @override
  Future<DataState<List<OrderEntity>>> getOrderByUser(
    GetOrderParams? params,
  ) async {
    return await orderByUserRemote.getOrderByQuery(params);
  }

  @override
  Future<DataState<List<OrderEntity>>> getOrderByOrderId(String? params) async {
    return await orderByUserRemote.getOrderByOrderId(params);
  }

  @override
  Future<DataState<bool>> updateOrder(UpdateOrderParams params) async {
    return await orderByUserRemote.updateOrder(params);
  }

  @override
  Future<DataState<ReturnEligibilityModel>> checkReturnEligibility(
    ReturnEligibilityParams params
  ) async {
    return await orderByUserRemote.checkReturnEligibility(params);
  }

  @override
  Future<DataState<bool>> orderReturn(OrderReturnParams params) async {
    return await orderByUserRemote.orderReturn(params);
  }
}
