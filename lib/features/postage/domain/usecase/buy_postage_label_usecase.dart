import '../../../../../../core/usecase/usecase.dart';
import '../params/add_postage_label_params.dart';
import '../repository/postage_repository.dart';

class BuyPostageLabelUsecase implements UseCase<bool, BuyPostageLabelParams> {
  const BuyPostageLabelUsecase(this._repository);
  final PostageRepository _repository;

  @override
  Future<DataState<bool>> call(BuyPostageLabelParams param) async {
    return await _repository.buyPostageLabel(param);
  }
}
