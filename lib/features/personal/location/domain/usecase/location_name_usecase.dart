import '../../../../../core/usecase/usecase.dart';
import '../entities/nomaintioon_location_entity/nomination_location_entity.dart';
import '../repo/location_repo.dart';

class NominationLocationUsecase
    implements UseCase<List<NominationLocationEntity>, String> {
  NominationLocationUsecase(this.repository);
  final LocationRepo repository;
  @override
  Future<DataState<List<NominationLocationEntity>>> call(String input) {
    return repository.fetchNominationLocations(input);
  }
}
