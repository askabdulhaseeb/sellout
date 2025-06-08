import '../../../post/data/models/post_model.dart';
import '../../../user/profiles/data/models/user_model.dart';
import '../../../../business/core/data/models/service/service_model.dart';
import '../../domain/entities/search_entity.dart';

class SearchModel extends SearchEntity {
  SearchModel({
    List<PostModel>? posts,
    List<UserModel>? users,
    List<ServiceModel>? services,
    required int count,
    String? lastEvaluatedKey,
  }) : super(
          posts: posts,
          users: users,
          services: services,
          count: count,
          lastEvaluatedKey: lastEvaluatedKey,
        );

  factory SearchModel.fromJson(Map<String, dynamic> json, String entityType) {
    final List itemsJson = json['items'] as List<dynamic>? ?? <dynamic>[];

    if (entityType == 'posts') {
      return SearchModel(
        posts: itemsJson.map((e) => PostModel.fromJson(e)).toList(),
        count: json['count'] ?? 0,
        lastEvaluatedKey: json['last_evaluated_key'],
      );
    } else if (entityType == 'users') {
      return SearchModel(
        users: itemsJson.map((e) => UserModel.fromJson(e)).toList(),
        count: json['count'] ?? 0,
        lastEvaluatedKey: json['last_evaluated_key'],
      );
    } else if (entityType == 'services') {
      return SearchModel(
        services: itemsJson.map((e) => ServiceModel.fromJson(e)).toList(),
        count: json['count'] ?? 0,
        lastEvaluatedKey: json['last_evaluated_key'],
      );
    } else {
      return SearchModel(
        count: json['count'] ?? 0,
        lastEvaluatedKey: json['last_evaluated_key'],
      );
    }
  }
}
