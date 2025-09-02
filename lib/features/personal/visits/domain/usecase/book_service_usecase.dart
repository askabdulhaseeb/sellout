import '../../../../../core/usecase/usecase.dart';
import '../../view/book_visit/params/book_service_params.dart';
import '../repo/book_visit_repo.dart';

class BookServiceUsecase implements UseCase<bool, BookServiceParams> {
  BookServiceUsecase(this.repository);
  final BookVisitRepo repository;

  @override
  Future<DataState<bool>> call(BookServiceParams params) {
    return repository.bookservice(params);
  }
}
