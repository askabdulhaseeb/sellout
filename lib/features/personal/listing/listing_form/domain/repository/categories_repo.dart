import '../../../../../../core/sources/api_call.dart';

abstract interface class CategoriesRepo {
  Future<DataState<String>> getCategoriesByEndPoint(String params);
}
