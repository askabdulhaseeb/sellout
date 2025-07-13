import '../../../../../core/usecase/usecase.dart';
import '../repo/order_repo.dart';
import '../../../user/profiles/domain/params/update_order_params.dart';

class UpdateOrderUsecase implements UseCase<bool, UpdateOrderParams> {
  const UpdateOrderUsecase(this.userProfileRepository);
  final OrderRepository userProfileRepository;
  @override
  Future<DataState<bool>> call(UpdateOrderParams params) async {
    return await userProfileRepository.updateOrder(params);
  }
}
