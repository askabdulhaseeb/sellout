import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/params/search_enum.dart';
import '../../domain/repository/search_repository.dart';
import '../source/search_remote_source.dart';

class SearchRepositoryImpl implements SearchRepository {

  SearchRepositoryImpl(this._remoteDataSource);
   SearchRemoteDataSource _remoteDataSource;

  @override
  Future<DataState<SearchEntity>> search(
       SearchParams params
  ) async {
    return await _remoteDataSource.searchData(params);
  }
}
