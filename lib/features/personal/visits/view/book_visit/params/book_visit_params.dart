class BookVisitParams {
  BookVisitParams({
    required this.dateTime,
    required this.postId,
  });
  final String dateTime;
  final String postId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date_time': dateTime,
      'post_id': postId,
    };
  }
}
