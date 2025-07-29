import '../../../post/data/models/post_model.dart';
import '../../../user/profiles/data/models/user_model.dart';
import '../../../../business/core/data/models/service/service_model.dart';
import '../../domain/entities/search_entity.dart';

class SearchModel extends SearchEntity {
  SearchModel({
    required super.count,
    List<PostModel>? super.posts,
    List<UserModel>? super.users,
    List<ServiceModel>? super.services,
    super.lastEvaluatedKey,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json, String entityType) {
    final List<dynamic> itemsJson =
        json['items'] as List<dynamic>? ?? <dynamic>[];

    if (entityType == 'posts') {
      return SearchModel(
        posts: itemsJson.map((dynamic e) => PostModel.fromJson(e)).toList(),
        count: json['count'] ?? 0,
        lastEvaluatedKey: json['last_evaluated_key'],
      );
    } else if (entityType == 'users') {
      return SearchModel(
        users: itemsJson.map((dynamic e) => UserModel.fromJson(e)).toList(),
        count: json['count'] ?? 0,
        lastEvaluatedKey: json['last_evaluated_key'],
      );
    } else if (entityType == 'services') {
      return SearchModel(
        services:
            itemsJson.map((dynamic e) => ServiceModel.fromJson(e)).toList(),
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
