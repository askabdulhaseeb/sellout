import '../../../../../../core/usecase/usecase.dart';
import '../repository/categories_repo.dart';

class GetCategoryByEndpointUsecase implements UseCase<String, String> {
  const GetCategoryByEndpointUsecase(this.repository);
  final CategoriesRepo repository;

  @override
  Future<DataState<String>> call(String params) async =>
      await repository.getCategoriesByEndPoint(params);
}
