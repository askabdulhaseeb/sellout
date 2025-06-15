import '../../../../../core/sources/data_state.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../domain/repo/book_visit_repo.dart';
import '../../view/params/book_service_params.dart';
import '../../view/params/book_visit_params.dart';
import '../../view/params/update_visit_params.dart';
import '../source/book_visit_api.dart';

class BookVisitRepoImpl implements BookVisitRepo {
  BookVisitRepoImpl(this.bookvisitapi);
  final BookVisitApi bookvisitapi;
  @override
  Future<DataState<VisitingEntity>> bookvisit(BookVisitParams params) {
    return bookvisitapi.bookVisit(params);
  }

  // @override
  // Future<DataState<VisitingEntity>> updateVisitStatus(
  //     UpdateVisitParams params) async {
  //   return await bookvisitapi.updateVisitStatus(params);
  // }

  @override
  Future<DataState<VisitingEntity>> updateVisit(
      UpdateVisitParams params) async {
    return await bookvisitapi.updateVisit(params);
  }

  @override
  Future<DataState<VisitingEntity>> bookservice(BookServiceParams params) {
    return bookvisitapi.bookService(params);
  }

  @override
  Future<DataState<List<VisitingEntity>>> getPostVisits(String postID) {
    return bookvisitapi.getPostVisits(postID);
  }
}
