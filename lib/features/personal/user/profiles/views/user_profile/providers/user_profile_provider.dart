import 'package:flutter/material.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../review/domain/entities/review_entity.dart';
import '../../../../../review/domain/param/get_review_param.dart';
import '../../../../../review/domain/usecase/get_reviews_usecase.dart';
import '../../../../../post/domain/entities/post/post_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecase/get_post_by_id_usecase.dart';
import '../../../domain/usecase/get_user_by_uid.dart';
import '../enums/user_profile_page_tab_type.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfileProvider(
    this._getUserByUidUsecase,
    this._getPostByIdUsecase,
    this._getReviewsUsecase,
  );

  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetReviewsUsecase _getReviewsUsecase;

  //---------------------------------------------------------------------------------variables
  DataState<UserEntity?>? _user;
  UserProfilePageTabType _displayType = UserProfilePageTabType.store;
  bool _isLoading = false;
  List<PostEntity>? _storePosts;
  List<PostEntity>? _viewingPosts;

  //---------------------------------------------------------------------------------getters
  UserEntity? get user => _user?.entity;
  UserProfilePageTabType get displayType => _displayType;
  bool get isLoading => _isLoading;
  List<PostEntity>? get storePosts => _storePosts;
  List<PostEntity>? get viewingPosts => _viewingPosts;

  //---------------------------------------------------------------------------------setters
  set displayType(UserProfilePageTabType value) {
    _displayType = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setStorePosts(List<PostEntity> value) {
    _storePosts = value;
    notifyListeners();
  }

  void setViewingPosts(List<PostEntity> value) {
    _viewingPosts = value;
    notifyListeners();
  }

  void reset() {
    _user = null;
    _displayType = UserProfilePageTabType.store;
    _isLoading = false;
    _storePosts = null;
    _viewingPosts = null;
  }

  //---------------------------------------------------------------------------------api usecases
  Future<DataState<UserEntity?>?> getUserByUid(String uid) async {
    _user = await _getUserByUidUsecase(uid);
    AppLog.info(
      'UserProfileProvider: User loaded: ${_user?.entity?.displayName}',
      name: 'UserProfileProvider.getUserByUid',
    );
    displayType = UserProfilePageTabType.store;
    return _user;
  }

  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await _getPostByIdUsecase(uid);
  }

  Future<List<ReviewEntity>> getReviews(String? uid) async {
    final DataState<List<ReviewEntity>> reviews = await _getReviewsUsecase(
      GetReviewParam(
        id: uid ?? _user?.entity?.uid ?? '',
        type: ReviewApiQueryOptionType.sellerID,
      ),
    );
    return reviews.entity ?? <ReviewEntity>[];
  }
}
