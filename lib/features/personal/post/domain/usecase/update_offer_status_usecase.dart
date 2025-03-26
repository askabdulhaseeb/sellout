import '../../../../../core/usecase/usecase.dart';
import '../params/update_offer_params.dart';
import '../repositories/post_repository.dart';

class UpdateOfferStatusUsecase implements UseCase<bool, UpdateOfferParams> {
  const UpdateOfferStatusUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(UpdateOfferParams post) async {
    return await repository.updateOfferStatus(post);
  }
}
