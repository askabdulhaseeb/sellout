import '../../../../../core/usecase/usecase.dart';
import '../../../chats/chat/domain/repositories/message_reposity.dart';
import '../params/update_offer_params.dart';

class UpdateOfferUsecase implements UseCase<bool, UpdateOfferParams> {
  const UpdateOfferUsecase(this.repository);
  final MessageRepository repository;

  @override
  Future<DataState<bool>> call(UpdateOfferParams post) async {
    return await repository.updateOffer(post);
  }
}
