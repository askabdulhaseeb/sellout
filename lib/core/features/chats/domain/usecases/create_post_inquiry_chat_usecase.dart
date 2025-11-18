import '../repositories/chat_repository.dart';

class CreatePostInquiryChatUsecase {

  CreatePostInquiryChatUsecase(this.repository);
  final ChatRepository repository;

  /// Calls the repository to create a post inquiry chat
  Future<void> call({required String postId, required String text}) async {
    await repository.createPostInquiryChat(postId: postId, text: text);
  }
}
