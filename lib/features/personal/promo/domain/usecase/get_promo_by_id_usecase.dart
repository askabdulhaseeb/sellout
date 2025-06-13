import '../../../../../core/usecase/usecase.dart';
import '../entities/promo_entity.dart';
import '../repo/promo_repo.dart';

class GetPromoByIdUsecase implements UseCase<List<PromoEntity>,String> {
  const GetPromoByIdUsecase(this.repository);
  final PromoRepository repository;
  @override
  Future<DataState<List<PromoEntity>>> call(String id) async {
    return await repository.getPromoByid(id);
  }
}
