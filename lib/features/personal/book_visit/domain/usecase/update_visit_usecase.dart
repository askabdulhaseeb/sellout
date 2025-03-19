import '../../../../../core/usecase/usecase.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/params/update_visit_params.dart';
import '../repo/book_visit_repo.dart';

class UpdateVisitUseCase implements UseCase<VisitingEntity, UpdateVisitParams> {
  UpdateVisitUseCase(this.repository);
  final BookVisitRepo repository;

  @override
  Future<DataState<VisitingEntity>> call(UpdateVisitParams params) {
    return repository.updateVisit(params);
  }
}
