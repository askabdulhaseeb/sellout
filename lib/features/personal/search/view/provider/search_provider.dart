import 'package:flutter/material.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/params/search_enum.dart';
import '../../domain/usecase/search_usecase.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._searchUseCase);
  final SearchUsecase _searchUseCase;

  SearchEntity? searchResults;
  SearchParams? _params;

  String? lastEvaluatedKey;

  bool isLoading = false;
  String? error;

  void setParams(SearchEntityType type, String query, int pageSize) {
    _params = SearchParams(
      entityType: type,
      query: query,
      pageSize: pageSize,
    );
    lastEvaluatedKey = null;
  }

  Future<void> search() async {
    if (_params == null) return;

    isLoading = true;
    error = null;
    searchResults = null;
    notifyListeners();

    try {
      final DataState<SearchEntity> result = await _searchUseCase.call(_params!);
      searchResults = result.entity;
      lastEvaluatedKey = searchResults?.lastEvaluatedKey;
    } catch (e) {
      error = 'Failed to load ${_params!.entityType}: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

 Future<void> loadMore() async {
  if (_params == null || lastEvaluatedKey == null || lastEvaluatedKey == '' || lastEvaluatedKey == 'null') {
    return;
  }

  try {
    final SearchParams newParams = _params!.copyWith(lastEvaluatedKey: lastEvaluatedKey);
    final DataState<SearchEntity> result = await _searchUseCase.call(newParams);

    if (result.entity != null) {
      final SearchEntity newEntity = result.entity!;
      // Create sets of existing IDs to avoid duplicates
      final Set<dynamic> existingPostIds = searchResults?.posts?.map((PostEntity e) => e.postID).toSet() ?? <dynamic>{};
      final Set<dynamic> existingUserIds = searchResults?.users?.map((UserEntity e) => e.uid).toSet() ?? <dynamic>{};
      final Set<dynamic> existingServiceIds = searchResults?.services?.map((ServiceEntity e) => e.serviceID).toSet() ?? <dynamic>{};

      // Filter out duplicates from newEntity
      final List<PostEntity>? filteredPosts = newEntity.posts?.where((PostEntity e) => !existingPostIds.contains(e.postID)).toList();
      final List<UserEntity>? filteredUsers = newEntity.users?.where((UserEntity e) => !existingUserIds.contains(e.uid)).toList();
      final List<ServiceEntity>? filteredServices = newEntity.services?.where((ServiceEntity e) => !existingServiceIds.contains(e.serviceID)).toList();

      searchResults = searchResults!.copyWith(
        posts: <PostEntity>[
          ...?searchResults!.posts,
          ...?filteredPosts,
        ],
        users: <UserEntity>[
          ...?searchResults!.users,
          ...?filteredUsers,
        ],
        services: <ServiceEntity>[
          ...?searchResults!.services,
          ...?filteredServices,
        ],
        lastEvaluatedKey: newEntity.lastEvaluatedKey,
      );

      lastEvaluatedKey = newEntity.lastEvaluatedKey;
      notifyListeners();
    }
  } catch (e) {
    error = 'Failed to load more: ${e.toString()}';
    notifyListeners();
  }
}

  void reset() {
    _params = null;
    searchResults = null;
    lastEvaluatedKey = null;
    error = null;
    notifyListeners();
  }
}
