import '../../../../../core/usecase/usecase.dart';
import '../../data/models/location_model.dart';
import '../entities/location_entity.dart';
import '../repo/location_repo.dart';

class NominationLocationUsecase
    implements UseCase<List<LocationEntity>, String> {
  NominationLocationUsecase(this.repository);
  final LocationRepo repository;
  @override
  Future<DataState<List<LocationModel>>> call(String input) {
    return repository.fetchNominationLocations(input);
  }
}
