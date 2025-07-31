import '../../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repo/order_repo.dart';

class GetOrderByOrderIdUsecase implements UseCase<List<OrderEntity>, String> {
  const GetOrderByOrderIdUsecase(this.userProfileRepository);
  final OrderRepository userProfileRepository;
  @override
  Future<DataState<List<OrderEntity>>> call(String params) async {
    return await userProfileRepository.getOrderByOrderId(params);
  }
}
