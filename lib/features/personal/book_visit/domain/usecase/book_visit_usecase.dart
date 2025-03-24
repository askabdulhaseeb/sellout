import '../../../../../core/usecase/usecase.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/params/book_visit_params.dart';
import '../repo/book_visit_repo.dart';

class BookVisitUseCase implements UseCase<VisitingEntity, BookVisitParams> {

  BookVisitUseCase(this.repository);
  final BookVisitRepo repository;

  @override
  Future<DataState<VisitingEntity>> call(BookVisitParams params) {
    return repository.bookvisit(params);
  }
}
