import '../../../../../../core/usecase/usecase.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../repo/book_visit_repo.dart';

class GetVisitByPostUsecase implements UseCase<List<VisitingEntity>, String> {
  const GetVisitByPostUsecase(this.repository);
  final BookVisitRepo repository;

  @override
  Future<DataState<List<VisitingEntity>>> call(String postID) async {
    return await repository.getPostVisits(postID);
  }
}
