import '../../../../../core/usecase/usecase.dart';
import '../entities/promo_entity.dart';
import '../repo/promo_repo.dart';

class GetPromoFollowerUseCase implements UseCase<List<PromoEntity>,void> {
  const GetPromoFollowerUseCase(this.repository);
  final PromoRepository repository;

  @override
  Future<DataState<List<PromoEntity>>> call(void _) async {
    return await repository.getPromoOfFollower();
  }
}
