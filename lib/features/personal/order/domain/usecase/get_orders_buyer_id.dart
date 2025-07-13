import '../../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repo/order_repo.dart';

class GetOrderByUidUsecase implements UseCase<List<OrderEntity>, String> {
  const GetOrderByUidUsecase(this.userProfileRepository);
  final OrderRepository userProfileRepository;
  @override
  Future<DataState<List<OrderEntity>>> call(String params) async {
    return await userProfileRepository.getOrderByUser(params);
  }
}
