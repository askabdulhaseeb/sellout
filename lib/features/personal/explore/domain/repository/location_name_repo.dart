import '../../../../../core/sources/data_state.dart';
import '../../views/params/location_by_name_params.dart';
import '../entities/location_name_entity.dart';

abstract interface class ExploreRepository {
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(
      FetchLocationParams params);
}
