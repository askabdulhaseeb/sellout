import '../../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../params/get_order_params.dart';
import '../repo/order_repo.dart';

class GetOrderByUidUsecase
    implements UseCase<List<OrderEntity>, GetOrderParams> {
  const GetOrderByUidUsecase(this.userProfileRepository);
  final OrderRepository userProfileRepository;
  @override
  Future<DataState<List<OrderEntity>>> call(GetOrderParams params) async {
    return await userProfileRepository.getOrderByUser(params);
  }
}
