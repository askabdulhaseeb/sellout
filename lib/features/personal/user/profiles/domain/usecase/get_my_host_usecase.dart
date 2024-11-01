import '../../../../../../core/usecase/usecase.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../repositories/user_repositories.dart';

class GetImHostUsecase implements UseCase<List<VisitingEntity>, void> {
  const GetImHostUsecase(this.repository);
  final UserProfileRepository repository;

  @override
  Future<DataState<List<VisitingEntity>>> call(_) async {
    return await repository.iMhost();
  }
}
