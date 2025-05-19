import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/location_name_entity.dart';
import '../../domain/repository/location_name_repo.dart';
import '../source/explore_remote_source.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl(this.remoteSource);
  final ExploreRemoteSource remoteSource;

  @override
  Future<DataState<List<LocationNameEntity>>> fetchLocationNames(
      String params) {
    return remoteSource.fetchLocationNames(params);
  }
}
