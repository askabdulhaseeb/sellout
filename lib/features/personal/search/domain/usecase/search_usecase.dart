
import '../../../../../core/usecase/usecase.dart';
import '../entities/search_entity.dart';
import '../params/search_enum.dart';
import '../repository/search_repository.dart';

class SearchUsecase implements UseCase<SearchEntity,SearchParams> {
  const SearchUsecase(this.repository);
  final SearchRepository repository;
  
  @override
  Future<DataState<SearchEntity>> call(SearchParams params) async {
    return repository.search(params);
  }
}
