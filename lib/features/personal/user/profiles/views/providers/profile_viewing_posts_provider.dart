import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import '../../../../marketplace/domain/params/post_by_filter_params.dart';
import '../../../../marketplace/domain/usecase/post_by_filters_usecase.dart';
import '../../../../marketplace/views/enums/sort_enums.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';

class ProfileViewingPostsProvider extends ChangeNotifier {
  ProfileViewingPostsProvider(this._getPostByFiltersUsecase, {String? userUid})
    : _userUid = userUid;

  final GetPostByFiltersUsecase _getPostByFiltersUsecase;
  final String? _userUid;

  bool _isLoading = false;
  SortOption? _sort;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  String? _mainPageKey;
  ListingType? _category;
  List<PostEntity>? _posts;

  bool get isLoading => _isLoading;
  SortOption? get sort => _sort;
  TextEditingController get minPriceController => _minPriceController;
  TextEditingController get maxPriceController => _maxPriceController;
  TextEditingController get queryController => _queryController;
  String? get mainPageKey => _mainPageKey;
  ListingType? get category => _category;
  List<PostEntity>? get posts => _posts;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSort(SortOption? value) {
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
    await loadPosts();
  }

  Future<void> filterSheetApply() async {
    await loadPosts();
  }

  Future<bool> loadPosts() async {
    setLoading(true);
    _mainPageKey = '';

    try {
      final PostByFiltersParams params = _buildParams();
      final DataState<List<PostEntity>> result = await _getPostByFiltersUsecase(
        params,
      );

      if (result is DataSuccess<List<PostEntity>>) {
        _posts = result.entity ?? <PostEntity>[];
        _mainPageKey = result.data;
        notifyListeners();
        return true;
      }

      _posts = <PostEntity>[];
      if (kDebugMode) {
        AppLog.error(
          'Failed: ${result.exception?.message ?? 'something_wrong'.tr()}',
          name: 'ProfileViewingPostsProvider.loadPosts',
        );
      }
      notifyListeners();
    } catch (e) {
      _posts = <PostEntity>[];
      if (kDebugMode) {
        AppLog.error(
          'Unexpected error: $e',
          name: 'ProfileViewingPostsProvider.loadPosts',
        );
      }
      notifyListeners();
    } finally {
      setLoading(false);
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
        valueList: ListingType.viewingList
            .map((ListingType e) => e.json)
            .toList(),
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

    return filters;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _queryController.dispose();
    super.dispose();
  }
}
