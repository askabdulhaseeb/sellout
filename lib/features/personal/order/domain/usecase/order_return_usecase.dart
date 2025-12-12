import '../../../../../core/usecase/usecase.dart';
import '../params/order_return_params.dart';
import '../repo/order_repo.dart';

class OrderReturnUsecase implements UseCase<bool, OrderReturnParams> {
  const OrderReturnUsecase(this.repository);

  final OrderRepository repository;

  @override
  Future<DataState<bool>> call(OrderReturnParams params) async {
    return await repository.orderReturn(params);
  }
}
