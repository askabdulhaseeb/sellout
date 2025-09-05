import '../../../../../core/sources/data_state.dart';
import '../../../location/domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';
import '../../domain/repo/location_repo.dart';
import '../source/location_api.dart';

class LocationRepoImpl implements LocationRepo {
  LocationRepoImpl(this.remoteSource);
  final LocationApi remoteSource;

  @override
  Future<DataState<List<NominationLocationEntity>>> fetchNominationLocations(
      String params) {
    return remoteSource.fetchNominationLocations(params);
  }
}
