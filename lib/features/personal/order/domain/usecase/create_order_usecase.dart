import '../../../../../core/usecase/usecase.dart';
import '../../data/models/order_model.dart';
import '../repo/order_repo.dart';

class CreateOrderUsecase implements UseCase<bool, List<OrderModel>> {
  const CreateOrderUsecase(this.userProfileRepository);
  final OrderRepository userProfileRepository;
  @override
  Future<DataState<bool>> call(List<OrderModel> params) async {
    return await userProfileRepository.createOrder(params);
  }
}
