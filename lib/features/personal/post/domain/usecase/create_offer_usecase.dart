import '../../../../../core/usecase/usecase.dart';
import '../params/create_offer_params.dart';
import '../repositories/post_repository.dart';

class CreateOfferUsecase implements UseCase<bool, CreateOfferparams> {
  const CreateOfferUsecase(this.repository);
  final PostRepository repository;

  @override
  Future<DataState<bool>> call(CreateOfferparams post) async {
    return await repository.createOffer(post);
  }
}
