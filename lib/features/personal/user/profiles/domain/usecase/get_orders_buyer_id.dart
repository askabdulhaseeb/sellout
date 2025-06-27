import '../../../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/user_repositories.dart';

class GetOrderByUidUsecase implements UseCase<List<OrderEntity>, String> {
  const GetOrderByUidUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<List<OrderEntity>>> call(String params) async {
    return await userProfileRepository.getOrderByUser(params);
  }
}
