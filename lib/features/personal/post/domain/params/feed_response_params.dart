import '../entities/post_entity.dart';

class GetFeedResponse {
  GetFeedResponse({required this.nextPageToken, required this.posts});
  final String? nextPageToken;
  final List<PostEntity> posts;
}
