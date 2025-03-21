import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/domain/param/get_review_param.dart';
import '../../../../review/domain/usecase/get_reviews_usecase.dart';
import '../../domain/entities/orderentity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/get_orders_buyer_id.dart';
import '../../domain/usecase/get_post_by_id_usecase.dart';
import '../../domain/usecase/get_user_by_uid.dart';
import '../enums/profile_page_tab_type.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(
    this._getUserByUidUsecase,
    this._getPostByIdUsecase,
    this._getReviewsUsecase,
    this._getOrderByIdUsecase,
  );
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;
  final GetReviewsUsecase _getReviewsUsecase;
  final GetOrderByUidUsecase _getOrderByIdUsecase;

  DataState<UserEntity?>? _user;
  UserEntity? get user => _user?.entity;

  ProfilePageTabType _displayType =
      kDebugMode ? ProfilePageTabType.viewing : ProfilePageTabType.orders;
  ProfilePageTabType get displayType => _displayType;

  set displayType(ProfilePageTabType value) {
    _displayType = value;
    notifyListeners();
  }

  Future<DataState<UserEntity?>?> getUserByUid({String? uid}) async {
    _user = await _getUserByUidUsecase(uid ?? LocalAuth.uid ?? '');
    AppLog.info(
      'Profile Provider: User loaded: ${_user?.entity?.displayName}',
      name: 'ProfileProvider.getUserByUid',
    );
    displayType = ProfilePageTabType.store;
    return _user;
  }

  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await _getPostByIdUsecase(uid);
  }

  Future<DataState<List<OrderEntity>?>> getOrderByUser(String uid) async {
    return await _getOrderByIdUsecase(uid);
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
