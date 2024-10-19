import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../domain/entities/post_entity.dart';
import '../../models/post_model.dart';
import '../local/local_post.dart';

abstract interface class PostRemoteApi {
  Future<DataState<List<PostEntity>>> getFeed();
}

class PostRemoteApiImpl implements PostRemoteApi {
  @override
  Future<DataState<List<PostEntity>>> getFeed() async {
    log('PostRemoteApiImpl.getFeed called');
    try {
      ApiRequestEntity? request = await LocalRequestHistory().request(
        endpoint: '/post',
        duration:
            kDebugMode ? const Duration(days: 1) : const Duration(minutes: 30),
      );
      if (request != null) {
        final List<PostEntity> list = LocalPost().all;
        if (list.isNotEmpty) {
          return DataSuccess<List<PostEntity>>(request.encodedData, list);
        }
      }
      //
      //

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/post',
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataFailer<List<PostEntity>>(
              result.exception ?? CustomException('something-wrong'.tr()));
        }
        final List<dynamic> listt = json.decode(raw)['response'];
        final List<PostEntity> list = <PostEntity>[];
        log('PostRemoteApiImpl.getFeed: Lenght: ${listt.length}');
        for (final dynamic item in listt) {
          final PostEntity post = PostModel.fromJson(item);
          await LocalPost().save(post);
          list.add(post);
        }
        return DataSuccess<List<PostEntity>>(raw, list);
      } else {
        log('PostRemoteApiImpl.getFeed failed: ${result.exception?.message}');
        return DataFailer<List<PostEntity>>(
          result.exception ?? CustomException('something-wrong'.tr()),
        );
      }
    } catch (e) {
      log('PostRemoteApiImpl.getFeed failed: $e');
      return DataFailer<List<PostEntity>>(CustomException(e.toString()));
    }
  }
}
