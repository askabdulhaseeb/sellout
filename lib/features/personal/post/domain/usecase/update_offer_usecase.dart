import '../../../../../core/usecase/usecase.dart';
import '../params/update_offer_params.dart';
import '../repositories/post_repository.dart';

class UpdateOfferUsecase implements UseCase<bool, UpdateOfferParams> {
  const UpdateOfferUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(UpdateOfferParams post) async {
    return await repository.updateOffer(post);
  }
}
