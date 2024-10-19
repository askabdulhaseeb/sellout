import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/sources/api_call.dart';
import '../../models/post_model.dart';
import '../local/local_post.dart';

abstract interface class PostRemoteApi {
  Future<DataState<List<PostModel>>> getFeed();
}

class PostRemoteApiImpl implements PostRemoteApi {
  @override
  Future<DataState<List<PostModel>>> getFeed() async {
    log('PostRemoteApiImpl.getFeed called');
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/post',
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataFailer<List<PostModel>>(
              result.exception ?? CustomException('something-wrong'.tr()));
        }
        final List<dynamic> listt = json.decode(raw)['response'];
        final List<PostModel> list = <PostModel>[];
        log('PostRemoteApiImpl.getFeed: Lenght: ${listt.length}');
        for (final dynamic item in listt) {
          final PostModel post = PostModel.fromJson(item);
          await LocalPost().save(post);
          list.add(post);
        }
        return DataSuccess<List<PostModel>>(raw, list);
      } else {
        log('PostRemoteApiImpl.getFeed failed: ${result.exception?.message}');
        return DataFailer<List<PostModel>>(
          result.exception ?? CustomException('something-wrong'.tr()),
        );
      }
    } catch (e) {
      log('PostRemoteApiImpl.getFeed failed: $e');
      return DataFailer<List<PostModel>>(CustomException(e.toString()));
    }
  }
}
