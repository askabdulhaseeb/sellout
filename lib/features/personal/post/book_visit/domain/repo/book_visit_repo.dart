import '../../../../../../core/sources/api_call.dart';
import '../../view/params/book_visit_params.dart';

abstract interface class BookVisitRepo {
  Future<DataState<bool>> bookvisit (BookVisitParams params);
}