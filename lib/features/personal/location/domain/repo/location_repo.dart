import '../../../../../core/sources/data_state.dart';
import '../../../location/domain/entities/nomaintioon_location_entity/nomination_location_entity.dart';

abstract interface class LocationRepo {
  Future<DataState<List<NominationLocationEntity>>> fetchNominationLocations(
      String params);
}
