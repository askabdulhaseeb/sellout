import '../enums/review_query_option_type.dart';
export '../enums/review_query_option_type.dart';

class GetReviewParam {
  GetReviewParam({
    required this.id,
    required this.type,
    this.duration,
  });

  final String id;
  final Duration? duration;
  final ReviewApiQueryOptionType type;

  String get query => '${type.json}=$id';
}
