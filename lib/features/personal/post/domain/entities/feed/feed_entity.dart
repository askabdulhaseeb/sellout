import 'package:hive_ce/hive.dart';
import '../post/post_entity.dart';
part 'feed_entity.g.dart';

@HiveType(typeId: 60)
class FeedEntity {
  FeedEntity({
    required this.endpointHash,
    required this.posts,
    required this.cachedAt,
    this.nextPageToken,
  });
  @HiveField(0)
  final String endpointHash;

  @HiveField(1)
  final List<PostEntity> posts;

  @HiveField(2)
  final String? nextPageToken;

  @HiveField(3)
  final DateTime cachedAt;
}
