class BookVisitParams {
  BookVisitParams({
    required this.dateTime,
    required this.postId,
    required this.businessId,
  });
  final String dateTime;
  final String postId;
  final String businessId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date_time': dateTime,
      'post_id': postId,
      'business_id': businessId,
    };
  }
}
