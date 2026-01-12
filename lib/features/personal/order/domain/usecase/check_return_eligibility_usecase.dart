import '../../../../../core/usecase/usecase.dart';
import '../../data/models/return_eligibility_model.dart';
import '../params/return_eligibility_params.dart';
import '../repo/order_repo.dart';
import '../entities/return_eligibility_entity.dart';

class CheckReturnEligibilityUsecase
    implements UseCase<ReturnEligibilityEntity, ReturnEligibilityParams> {
  const CheckReturnEligibilityUsecase(this.repository);

  final OrderRepository repository;

  @override
  Future<DataState<ReturnEligibilityModel>> call(ReturnEligibilityParams params) async {
    return await repository.checkReturnEligibility(params);
  }
}
