import '../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/params/create_promo_params.dart';
import '../../domain/repo/promo_repo.dart';
import '../source/remote/promo_remote_data_source.dart';

class PromoRepositoryImpl implements PromoRepository {
    PromoRepositoryImpl( this.promoRemoteApi);

  final PromoRemoteDataSource promoRemoteApi;
  @override
  Future<DataState<bool>> createPromo(CreatePromoParams promo) async {
   
  
    return await promoRemoteApi.createPromo(promo);
    }
    @override
  Future<DataState<List<PromoEntity>>> getPromoOfFollower() async {
   
  
    return await promoRemoteApi.getPromoOfFollower();
    }
}
