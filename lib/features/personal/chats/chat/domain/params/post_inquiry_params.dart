class PostInquiryParams {
  PostInquiryParams({
    required this.postId,
    required this.text,
  });

  final String postId;
  final String text;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'post_id': postId,
      'text': text,
    };
  }
}
