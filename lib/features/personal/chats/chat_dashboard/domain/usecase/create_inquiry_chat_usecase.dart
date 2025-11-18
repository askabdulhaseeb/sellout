import '../../../../../../core/usecase/usecase.dart';
import '../../../chat/domain/params/post_inquiry_params.dart';
import '../entities/chat/chat_entity.dart';
import '../repositories/chat_repository.dart';

class CreateInquiryChatUseacse implements UseCase<ChatEntity, PostInquiryParams> {
  const CreateInquiryChatUseacse(this.repository);
  final ChatRepository repository;
  @override
  Future<DataState<ChatEntity>> call(PostInquiryParams params) async {
    return await repository.createInquiryChat(params);
  }
}
