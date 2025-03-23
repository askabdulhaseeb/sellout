import '../../../../../core/usecase/usecase.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/params/book_service_params.dart';
import '../repo/book_visit_repo.dart';

class BookServiceUsecase implements UseCase<VisitingEntity, BookServiceParams> {

  BookServiceUsecase(this.repository);
  final BookVisitRepo repository;

  @override
  Future<DataState<VisitingEntity>> call(BookServiceParams params) {
    return repository.bookservice(params);
  }
}
