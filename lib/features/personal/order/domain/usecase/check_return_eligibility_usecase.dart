import '../../../../../core/usecase/usecase.dart';
import '../params/return_eligibility_params.dart';
import '../repo/order_repo.dart';
import '../entities/return_eligibility_entity.dart';

class CheckReturnEligibilityUsecase
    implements UseCase<ReturnEligibilityEntity, ReturnEligibilityParams> {
  const CheckReturnEligibilityUsecase(this.repository);

  final OrderRepository repository;

  @override
  Future<DataState<ReturnEligibilityEntity>> call(
    ReturnEligibilityParams params,
  ) async {
    return await repository.checkReturnEligibility(params);
  }
}
