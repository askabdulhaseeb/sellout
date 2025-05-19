import '../../../../../core/usecase/usecase.dart';
import '../entities/location_name_entity.dart';
import '../repository/location_name_repo.dart';

class LocationByNameUsecase
    implements UseCase<List<LocationNameEntity>, String> {
  LocationByNameUsecase(this.repository);
  final ExploreRepository repository;

  @override
  Future<DataState<List<LocationNameEntity>>> call(String input) {
    return repository.fetchLocationNames(input);
  }
}
