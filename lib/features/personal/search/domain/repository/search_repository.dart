import '../../../../../core/sources/data_state.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/params/search_enum.dart';

abstract class SearchRepository {
  Future<DataState<SearchEntity>> search(
    SearchParams params
  );
}
