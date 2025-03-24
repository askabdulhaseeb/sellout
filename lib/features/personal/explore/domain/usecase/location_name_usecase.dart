import '../../../../../core/usecase/usecase.dart';
import '../../views/params/location_by_name_params.dart';
import '../entities/location_name_entity.dart';
import '../repository/location_name_repo.dart';

class LocationByNameUsecase
    implements UseCase<List<LocationNameEntity>, FetchLocationParams> {
  LocationByNameUsecase(this.repository);
  final ExploreRepository repository;

  @override
  Future<DataState<List<LocationNameEntity>>> call(FetchLocationParams params) {
    return repository.fetchLocationNames(params);
  }
}
