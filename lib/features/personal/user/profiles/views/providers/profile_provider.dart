import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/domain/param/get_review_param.dart';
import '../../../../review/domain/usecase/get_reviews_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/get_post_by_id_usecase.dart';
import '../../domain/usecase/get_user_by_uid.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(
    this._getUserByUidUsecase,
    this._getPostByIdUsecase,
    this._getReviewsUsecase,
  );
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetReviewsUsecase _getReviewsUsecase;

  DataState<UserEntity?>? _user;
  UserEntity? get user => _user?.entity;

  int _displayType = kDebugMode ? 0 : 0;
  int get displayType => _displayType;

  set displayType(int value) {
    _displayType = value;
    notifyListeners();
  }

  Future<DataState<UserEntity?>?> getUserByUid({String? uid}) async {
    _user = await _getUserByUidUsecase(uid ?? LocalAuth.uid ?? '');
    AppLog.info(
      'Profile Provider: User loaded: ${_user?.entity?.displayName}',
      name: 'ProfileProvider.getUserByUid',
    );
    displayType = kDebugMode ? 0 : 0;
    return _user;
  }

  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await _getPostByIdUsecase(uid);
  }

  Future<List<ReviewEntity>> getReviews(String? uid) async {
    final DataState<List<ReviewEntity>> reviews =
        await _getReviewsUsecase(GetReviewParam(
      id: uid ?? _user?.entity?.uid ?? '',
      type: ReviewApiQueryOptionType.sellerID,
    ));
    return reviews.entity ?? <ReviewEntity>[];
  }
}
