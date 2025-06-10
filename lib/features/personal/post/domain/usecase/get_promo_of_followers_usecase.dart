import '../../../../../core/usecase/usecase.dart';
import '../repositories/post_repository.dart';

class GetPromoFollowerUseCase implements UseCase<bool,void> {
  const GetPromoFollowerUseCase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(void _) async {
    return await repository.getPromoOfFollower();
  }
}
