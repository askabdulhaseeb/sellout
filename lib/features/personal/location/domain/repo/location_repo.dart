import '../../../../../core/sources/data_state.dart';
import '../../data/models/location_model.dart';

abstract interface class LocationRepo {
  Future<DataState<List<LocationModel>>> fetchNominationLocations(
    String params,
  );
}
