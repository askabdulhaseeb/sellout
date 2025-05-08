import '../../../../../core/sources/data_state.dart';
import '../entities/location_name_entity.dart';

abstract interface class ExploreRepository {
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(
      String params);
}
