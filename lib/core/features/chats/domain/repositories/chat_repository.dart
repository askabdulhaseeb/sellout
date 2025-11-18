abstract class ChatRepository {
  Future<void> createPostInquiryChat(
      {required String postId, required String text});
}
