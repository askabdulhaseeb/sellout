import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/location_name_entity.dart';
import '../../domain/repository/location_name_repo.dart';
import '../../views/params/location_by_name_params.dart';
import '../models/location_name_model.dart';
import '../source/explore_remote_source.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl(this.remoteSource);
  final ExploreRemoteSource remoteSource;

  @override
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(
      FetchLocationParams params) {
    return remoteSource.fetchLocationNames(params);
  }
}
