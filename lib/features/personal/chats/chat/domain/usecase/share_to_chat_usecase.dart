import '../../../../../../core/usecase/usecase.dart';
import '../../../../post/domain/params/share_in_chat_params.dart';
import '../repositories/message_reposity.dart';

class ShareInChatUsecase implements UseCase<bool, ShareInChatParams> {
  const ShareInChatUsecase(this.repository);
  final MessageRepository repository;
  @override
  Future<DataState<bool>> call(ShareInChatParams params) async {
    return await repository.sharePostToChat(params);
  }
}
