import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecase/get_feed_usecase.dart';

class FeedProvider extends ChangeNotifier {
  FeedProvider(this._getFeedUsecase);
  final GetFeedUsecase _getFeedUsecase;

  final List<PostEntity> _posts = <PostEntity>[];
  List<PostEntity> get feed => _posts;

  Future<DataState<List<PostEntity>>> getFeed() async {
    final DataState<List<PostEntity>> result = await _getFeedUsecase(null);
    _posts.addAll(result.entity ?? <PostEntity>[]);
    notifyListeners();
    log('FeedProvider.getFeed: ${result.runtimeType}');
    return result;
  }
}
