import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import '../../../../marketplace/domain/params/post_by_filter_params.dart';
import '../../../../marketplace/domain/usecase/post_by_filters_usecase.dart';
import '../../../../marketplace/views/enums/sort_enums.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../enums/profile_grid_state.dart';

abstract class BaseProfilePostsProvider extends ChangeNotifier {
  BaseProfilePostsProvider(this._getPostByFiltersUsecase, {String? userUid})
    : _userUid = userUid;

  final GetPostByFiltersUsecase _getPostByFiltersUsecase;
  final String? _userUid;
  bool _isDisposed = false;

  ProfileGridState _state = ProfileGridState.initial;
  SortOption? _sort;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  String? _mainPageKey;
  ListingType? _category;
  List<PostEntity>? _posts;
  String? _errorMessage;

  // Getters
  ProfileGridState get state => _state;
  bool get isLoading => _state.isLoading;
  SortOption? get sort => _sort;
  TextEditingController get minPriceController => _minPriceController;
  TextEditingController get maxPriceController => _maxPriceController;
  TextEditingController get queryController => _queryController;
  String? get mainPageKey => _mainPageKey;
  ListingType? get category => _category;
  List<PostEntity>? get posts => _posts;
  String? get errorMessage => _errorMessage;

  @protected
  bool get isDisposed => _isDisposed;

  /// Override in subclass to provide the listing types for filtering
  List<ListingType> get listingTypes;

  /// Override in subclass to provide additional filters
  List<FilterParam> get additionalFilters => <FilterParam>[];

  /// Provider name for logging
  String get providerName;

  void _setState(ProfileGridState newState) {
    if (_isDisposed) return;
    _state = newState;
    notifyListeners();
  }

  void setSort(SortOption? value) {
    if (_isDisposed) return;
    _sort = value;
    notifyListeners();
  }

  void setCategory(ListingType? value) {
    _category = value;
    loadPosts();
  }

  void resetCategory() {
    _category = null;
    loadPosts();
  }

  Future<void> filterSheetReset() async {
    _minPriceController.clear();
    _maxPriceController.clear();
    setSort(null);
    resetAdditionalFilters();
    await loadPosts();
  }

  /// Override in subclass to reset additional filters
  void resetAdditionalFilters() {}

  Future<void> filterSheetApply() async {
    await loadPosts();
  }

  Future<bool> loadPosts() async {
    _setState(ProfileGridState.loading);
    _mainPageKey = '';
    _errorMessage = null;

    try {
      final PostByFiltersParams params = _buildParams();
      final DataState<List<PostEntity>> result = await _getPostByFiltersUsecase(
        params,
      );

      if (result is DataSuccess<List<PostEntity>>) {
        _posts = result.entity ?? <PostEntity>[];
        _mainPageKey = result.data;

        if (_posts!.isEmpty) {
          _setState(ProfileGridState.empty);
        } else {
          _setState(ProfileGridState.loaded);
        }
        return true;
      }

      _posts = <PostEntity>[];
      _errorMessage = result.exception?.message ?? 'something_wrong'.tr();

      if (kDebugMode) {
        AppLog.error('Failed: $_errorMessage', name: '$providerName.loadPosts');
      }

      _setState(ProfileGridState.error);
    } catch (e) {
      _posts = <PostEntity>[];
      _errorMessage = e.toString();

      if (kDebugMode) {
        AppLog.error('Unexpected error: $e', name: '$providerName.loadPosts');
      }

      _setState(ProfileGridState.error);
    }

    return false;
  }

  PostByFiltersParams _buildParams() {
    return PostByFiltersParams(
      lastKey: _mainPageKey,
      query: _queryController.text,
      sort: _sort,
      filters: _buildFilters(),
    );
  }

  List<FilterParam> _buildFilters() {
    final List<FilterParam> filters = <FilterParam>[];

    final String? createdByUid = _userUid ?? LocalAuth.uid;

    if (createdByUid != null && createdByUid.trim().isNotEmpty) {
      filters.add(
        FilterParam(
          attribute: 'created_by',
          operator: 'eq',
          value: createdByUid,
        ),
      );
    }

    filters.add(
      FilterParam(
        attribute: 'list_id',
        operator: _category != null ? 'eq' : 'inc',
        valueList: listingTypes.map((ListingType e) => e.json).toList(),
        value: _category?.json ?? '',
      ),
    );

    if (_minPriceController.text.trim().isNotEmpty) {
      filters.add(
        FilterParam(
          attribute: 'price',
          operator: 'gt',
          value: _minPriceController.text.trim(),
        ),
      );
    }

    if (_maxPriceController.text.trim().isNotEmpty) {
      filters.add(
        FilterParam(
          attribute: 'price',
          operator: 'lt',
          value: _maxPriceController.text.trim(),
        ),
      );
    }

    // Add any additional filters from subclass
    filters.addAll(additionalFilters);

    return filters;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _queryController.dispose();
    super.dispose();
  }
}
