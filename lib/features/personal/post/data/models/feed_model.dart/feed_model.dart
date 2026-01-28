import '../../../domain/entities/feed/feed_entity.dart';
import '../post/post_model.dart';

class FeedModel extends FeedEntity {
  FeedModel({
    required super.endpointHash,
    required super.posts,
    required super.cachedAt,
    super.nextPageToken,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      endpointHash: json['endpointHash'] as String,
      posts: (json['posts'] as List<dynamic>)
          .map((dynamic e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );
  }
}
