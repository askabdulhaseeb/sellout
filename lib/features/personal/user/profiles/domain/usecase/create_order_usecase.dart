import '../../../../../../core/usecase/usecase.dart';
import '../../data/models/order_model.dart';
import '../repositories/user_repositories.dart';

class CreateOrderUsecase implements UseCase<bool, List<OrderModel>> {
  const CreateOrderUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<bool>> call(List<OrderModel> params) async {
    return await userProfileRepository.createOrder(params);
  }
}
