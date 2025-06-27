import '../../../../../../core/usecase/usecase.dart';
import '../params/update_order_params.dart';
import '../repositories/user_repositories.dart';

class UpdateOrderUsecase implements UseCase<bool, UpdateOrderParams> {
  const UpdateOrderUsecase(this.userProfileRepository);
  final UserProfileRepository userProfileRepository;
  @override
  Future<DataState<bool>> call(UpdateOrderParams params) async {
    return await userProfileRepository.updateOrder(params);
  }
}
