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

  final ScrollController _postScrollController = ScrollController();
  final ScrollController _serviceScrollController = ScrollController();
  final ScrollController _userScrollController = ScrollController();

  String _postQuery = '';
  String _serviceQuery = '';
  String _userQuery = '';

  bool _isLoading = false;
  String? _nextPageToken;

  // Getters
  SearchEntityType get currentType => _currentType;
  bool get isLoading => _isLoading;

  List<PostEntity> get postResults => _postResults;
  List<ServiceEntity> get serviceResults => _serviceResults;
  List<UserEntity> get userResults => _userResults;

  String get postQuery => _postQuery;
  String get serviceQuery => _serviceQuery;
  String get userQuery => _userQuery;

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

  // Switch type without triggering search
  void switchType(SearchEntityType type) {
    if (_currentType != type) {
      _currentType = type;
      notifyListeners();
    }
  }

  // Search logic
  Future<void> search(String query, {bool isLoadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    if (!isLoadMore) {
      _nextPageToken = null;
      switch (_currentType) {
        case SearchEntityType.posts:
          _postQuery = query;
          break;
        case SearchEntityType.services:
          _serviceQuery = query;
          break;
        case SearchEntityType.users:
          _userQuery = query;
          break;
      }
    }

    final DataState<SearchEntity> result = await _searchUsecase.call(
      SearchParams(
        entityType: _currentType,
        query: query,
        pageSize: 20,
        lastEvaluatedKey: _nextPageToken ?? '',
      ),
    );

    if (result is DataSuccess<SearchEntity>) {
      final SearchEntity data = result.entity!;

      switch (_currentType) {
        case SearchEntityType.posts:
          if (!isLoadMore) {
            _postResults.clear();
          }
          _postResults.addAll(data.posts ?? <PostEntity>[]);
          break;

        case SearchEntityType.services:
          if (!isLoadMore) {
            _serviceResults.clear();
          }
          _serviceResults.addAll(data.services ?? <ServiceEntity>[]);
          break;

        case SearchEntityType.users:
          if (!isLoadMore) {
            _userResults.clear();
          }
          _userResults.addAll(data.users ?? <UserEntity>[]);
          break;
      }

      _nextPageToken = data.lastEvaluatedKey;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Reset everything
  void reset() {
    _postResults.clear();
    _serviceResults.clear();
    _userResults.clear();

    _postQuery = '';
    _serviceQuery = '';
    _userQuery = '';

    _nextPageToken = null;
    _isLoading = false;

    notifyListeners();
  }
}
