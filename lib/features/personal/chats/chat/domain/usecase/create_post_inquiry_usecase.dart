import '../../../../../../core/usecase/usecase.dart';
import '../params/post_inquiry_params.dart';
import '../repositories/message_reposity.dart';

class CreatePostInquiryUsecase implements UseCase<bool, PostInquiryParams> {
  const CreatePostInquiryUsecase(this.repository);
  final MessageRepository repository;

  @override
  Future<DataState<bool>> call(PostInquiryParams params) async {
    return await repository.createPostInquiry(params);
  }
}
