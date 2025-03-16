import '../../../../../../core/usecase/usecase.dart';
import '../../data/source/book_visit_api.dart';
import '../../view/params/book_visit_params.dart';
import '../repo/book_visit_repo.dart';

class BookVisitUseCase implements UseCase<bool, BookVisitParams> {

  BookVisitUseCase(this.repository);
  final BookVisitRepo repository;

  @override
  Future<DataState<bool>> call(BookVisitParams params) {
    return repository.bookvisit(params);
  }
}
