import '../../../../../core/usecase/usecase.dart';
import '../params/create_promo_params.dart';
import '../repo/promo_repo.dart';

class CreatePromoUsecase
    implements UseCase<bool, CreatePromoParams> {
  const CreatePromoUsecase(this.repository);
  final PromoRepository repository;

 @override
  Future<DataState<bool>> call(CreatePromoParams params) async {
    return await repository.createPromo(params);
  }
}
