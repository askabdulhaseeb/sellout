import '../../../../../../core/usecase/usecase.dart';
import '../params/add_lable_params.dart';
import '../repository/postage_repository.dart';

class BuyLabelUsecase implements UseCase<bool, BuyLabelParams> {
  const BuyLabelUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<bool>> call(BuyLabelParams param) async {
    return await _repository.buyLabel(param);
  }
}
