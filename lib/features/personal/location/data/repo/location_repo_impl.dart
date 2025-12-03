import '../../../../../core/sources/data_state.dart';
import '../../domain/repo/location_repo.dart';
import '../models/location_model.dart';
import '../source/location_api.dart';

class LocationRepoImpl implements LocationRepo {
  LocationRepoImpl(this.remoteSource);
  final LocationApi remoteSource;

  @override
  Future<DataState<List<LocationModel>>> fetchNominationLocations(
    String params,
  ) {
    return remoteSource.fetchNominationLocations(params);
  }
}
