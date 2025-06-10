import '../../../../../core/sources/data_state.dart';
import '../entities/promo_entity.dart';
import '../params/create_promo_params.dart';

abstract class PromoRepository {
Future<DataState<bool>> createPromo(CreatePromoParams promo);
 Future<DataState<List<PromoEntity>>> getPromoOfFollower();
}