import 'package:flutter/material.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../review/domain/entities/review_entity.dart';
import '../../../../review/domain/param/get_review_param.dart';
import '../../../../review/domain/usecase/get_reviews_usecase.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/usecase/get_specific_post_usecase.dart';

class PostDetailProvider extends ChangeNotifier {
  PostDetailProvider(this._getSpecificPostUsecase, this._getReviewsUsecase);
  final GetSpecificPostUsecase _getSpecificPostUsecase;
  final GetReviewsUsecase _getReviewsUsecase;

  PostEntity? _post;
  List<ReviewEntity> _reviews = <ReviewEntity>[];

  PostEntity? get post => _post;
  List<ReviewEntity> get reviews => _reviews;

  void _setPost(PostEntity? value) {
    _reviews = <ReviewEntity>[];
    //
    _post = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setReviews(List<ReviewEntity> value) {
    _reviews = value;
    _reviews
        .sort((ReviewEntity a, ReviewEntity b) => a.rating.compareTo(b.rating));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<DataState<List<ReviewEntity>>> getReviews(GetReviewParam param) async {
    try {
      if (_reviews.isNotEmpty) {
        return DataSuccess<List<ReviewEntity>>('', _reviews);
      }
      final DataState<List<ReviewEntity>> result =
          await _getReviewsUsecase(param);
      if (result is DataSuccess) {
        setReviews(result.entity ?? <ReviewEntity>[]);
        return result;
      } else {
        return result;
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostDetailProvider.getReviews - catch',
        error: e,
      );
      return DataFailer<List<ReviewEntity>>(CustomException(e.toString()));
    }
  }

  List<AttachmentEntity> get reviewAttachments => _reviews
      .map((ReviewEntity e) => e.fileUrls)
      .expand((List<AttachmentEntity> e) => e)
      .toList();

  Future<DataState<PostEntity>> getPost(String postId) async {
    final DataState<PostEntity> local = LocalPost().dataState(postId);

    if (local is DataSuccess) {
      _setPost(local.entity);
    }
    try {
      final DataState<PostEntity> result = await _getSpecificPostUsecase(
        GetSpecificPostParam(postId: postId, silentUpdate: false),
      );
      if (result is DataSuccess) {
        _setPost(result.entity);
        return result;
      } else {
        AppLog.error(
          result.exception?.message.toString() ?? 'something went wrong',
          name: 'PostDetailProvider.getPost - else',
          error: result.exception,
        );
        return _post == null ? result : local;
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostDetailProvider.getPost - catch',
        error: e,
      );
      return _post == null
          ? DataFailer<PostEntity>(CustomException(e.toString()))
          : local;
    }
  }
}
