import '../../../../../../core/sources/data_state.dart';
import '../../domain/repo/book_visit_repo.dart';
import '../../view/params/book_visit_params.dart';
import '../source/book_visit_api.dart';

class BookVisitRepoImpl implements BookVisitRepo {
  BookVisitRepoImpl(this.bookvisitapi);
  final BookVisitApi bookvisitapi;
  @override
  Future<DataState<bool>> bookvisit(BookVisitParams params) {
    return bookvisitapi.bookvisit(params);
  }
}
