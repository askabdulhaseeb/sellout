import '../../../../../core/sources/api_call.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/params/book_visit_params.dart';
import '../../view/params/update_visit_params.dart';

abstract interface class BookVisitRepo {
  Future<DataState<VisitingEntity>> bookvisit(BookVisitParams params);
  Future<DataState<VisitingEntity>> cancelVisit(UpdateVisitParams params);
  Future<DataState<VisitingEntity>> updateVisit(UpdateVisitParams params);
}
