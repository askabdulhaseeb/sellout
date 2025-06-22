import 'package:flutter/material.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/params/search_enum.dart';
import '../../domain/usecase/search_usecase.dart';
import '../../../post/domain/entities/post_entity.dart';
import '../../../user/profiles/domain/entities/user_entity.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._searchUsecase);
  final SearchUsecase _searchUsecase;

  SearchEntityType _currentType = SearchEntityType.posts;

  final List<PostEntity> _postResults = <PostEntity>[];
  final List<ServiceEntity> _serviceResults = <ServiceEntity>[];
  final List<UserEntity> _userResults = <UserEntity>[];

  String _postQuery = '';
  String _serviceQuery = '';
  String _userQuery = '';

  String? _postNextKey;
  String? _serviceNextKey;
  String? _userNextKey;

  bool _isLoading = false;

  final ScrollController _postScrollController = ScrollController();
  final ScrollController _serviceScrollController = ScrollController();
  final ScrollController _userScrollController = ScrollController();

  SearchEntityType get currentType => _currentType;
  bool get isLoading => _isLoading;

  List<PostEntity> get postResults => _postResults;
  List<ServiceEntity> get serviceResults => _serviceResults;
  List<UserEntity> get userResults => _userResults;

  String get postQuery => _postQuery;
  String get serviceQuery => _serviceQuery;
  String get userQuery => _userQuery;

  ScrollController get currentScrollController {
    switch (_currentType) {
      case SearchEntityType.posts:
        return _postScrollController;
      case SearchEntityType.services:
        return _serviceScrollController;
      case SearchEntityType.users:
        return _userScrollController;
    }
  }

  String get currentQuery {
    switch (_currentType) {
      case SearchEntityType.posts:
        return _postQuery;
      case SearchEntityType.services:
        return _serviceQuery;
      case SearchEntityType.users:
        return _userQuery;
    }
  }

  void switchType(SearchEntityType type) {
    if (_currentType != type) {
      _currentType = type;
      notifyListeners();
    }
  }

  Future<void> searchPosts(String query, {bool isLoadMore = false}) async {
    if (_isLoading || (isLoadMore && _postNextKey == null)) return;
    await _searchEntity(
      query: query,
      entityType: SearchEntityType.posts,
      isLoadMore: isLoadMore,
    );
  }

  Future<void> searchServices(String query, {bool isLoadMore = false}) async {
    if (_isLoading || (isLoadMore && _serviceNextKey == null)) return;
    await _searchEntity(
      query: query,
      entityType: SearchEntityType.services,
      isLoadMore: isLoadMore,
    );
  }

  Future<void> searchUsers(String query, {bool isLoadMore = false}) async {
    if (_isLoading || (isLoadMore && _userNextKey == null)) return;
    await _searchEntity(
      query: query,
      entityType: SearchEntityType.users,
      isLoadMore: isLoadMore,
    );
  }

  Future<void> _searchEntity({
    required String query,
    required SearchEntityType entityType,
    required bool isLoadMore,
  }) async {
    _isLoading = true;
    notifyListeners();

    String? lastKey;
    if (entityType == SearchEntityType.posts) {
      if (!isLoadMore) _postResults.clear();
      _postQuery = query;
      lastKey = _postNextKey;
    } else if (entityType == SearchEntityType.services) {
      if (!isLoadMore) _serviceResults.clear();
      _serviceQuery = query;
      lastKey = _serviceNextKey;
    } else if (entityType == SearchEntityType.users) {
      if (!isLoadMore) _userResults.clear();
      _userQuery = query;
      lastKey = _userNextKey;
    }

    final DataState<SearchEntity> result = await _searchUsecase.call(
      SearchParams(
        entityType: entityType,
        query: query,
        pageSize: 20,
        lastEvaluatedKey: isLoadMore ? (lastKey ?? '') : '',
      ),
    );

    if (result is DataSuccess<SearchEntity>) {
      final SearchEntity data = result.entity!;
      if (entityType == SearchEntityType.posts) {
        _postResults.addAll(data.posts ?? <PostEntity>[]);
        _postNextKey = data.lastEvaluatedKey;
      } else if (entityType == SearchEntityType.services) {
        _serviceResults.addAll(data.services ?? <ServiceEntity>[]);
        _serviceNextKey = data.lastEvaluatedKey;
      } else if (entityType == SearchEntityType.users) {
        _userResults.addAll(data.users ?? <UserEntity>[]);
        _userNextKey = data.lastEvaluatedKey;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _postResults.clear();
    _serviceResults.clear();
    _userResults.clear();

    _postQuery = '';
    _serviceQuery = '';
    _userQuery = '';

    _postNextKey = null;
    _serviceNextKey = null;
    _userNextKey = null;

    _isLoading = false;
    notifyListeners();
  }
}
