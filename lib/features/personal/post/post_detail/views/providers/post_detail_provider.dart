import 'package:flutter/material.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../data/sources/local/local_post.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecase/get_specific_post_usecase.dart';

class PostDetailProvider extends ChangeNotifier {
  PostDetailProvider(this._getSpecificPostUsecase);
  final GetSpecificPostUsecase _getSpecificPostUsecase;

  PostEntity? _post;
  PostEntity? get post => _post;
  void _setPost(PostEntity? value) {
    _post = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

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
