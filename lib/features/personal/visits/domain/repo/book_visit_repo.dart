import '../../../../../core/sources/api_call.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/book_visit/params/book_service_params.dart';
import '../../view/book_visit/params/book_visit_params.dart';
import '../../view/book_visit/params/update_visit_params.dart';

abstract interface class BookVisitRepo {
  Future<DataState<bool>> bookvisit(BookVisitParams params);
  Future<DataState<bool>> bookservice(BookServiceParams params);
  // Future<DataState<VisitingEntity>> updateVisitStatus(UpdateVisitParams params);
  Future<DataState<VisitingEntity>> updateVisit(UpdateVisitParams params);
  Future<DataState<List<VisitingEntity>>> getPostVisits(String postID);
}
