import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';

class SearchEntity {

  SearchEntity({
    required this.count, this.posts,
    this.users,
    this.services,
    this.lastEvaluatedKey,
  });
  final List<PostEntity>? posts;
  final List<UserEntity>? users;
  final List<ServiceEntity>? services;
  final int count;
  final String? lastEvaluatedKey;
  
  SearchEntity copyWith({
    List<PostEntity>? posts,
    List<UserEntity>? users,
    List<ServiceEntity>? services,
    int? count,
    String? lastEvaluatedKey,
  }) {
    return SearchEntity(
      posts: posts ?? this.posts,
      users: users ?? this.users,
      services: services ?? this.services,
      count: count ?? this.count,
      lastEvaluatedKey: lastEvaluatedKey ?? this.lastEvaluatedKey,
    );
  }
}
