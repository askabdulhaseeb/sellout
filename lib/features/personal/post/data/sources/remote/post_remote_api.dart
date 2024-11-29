import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../../services/get_it.dart';
import '../../../../cart/domain/usecase/cart/get_cart_usecase.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/params/add_to_cart_param.dart';
import '../../models/post_model.dart';
import '../local/local_post.dart';

abstract interface class PostRemoteApi {
  Future<DataState<List<PostEntity>>> getFeed();
  Future<DataState<PostEntity>> getPost(String id);
  Future<DataState<bool>> addToCart(AddToCartParam param);
}

class PostRemoteApiImpl implements PostRemoteApi {
  @override
  Future<DataState<List<PostEntity>>> getFeed() async {
    const String endpoint = '/post';
    try {
      ApiRequestEntity? request = await LocalRequestHistory().request(
        endpoint: endpoint,
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
      log('PostRemoteApiImpl.getFeed called');
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
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
        log('PostRemoteApiImpl.getFeed: Lenght: ${listt.length}');
        final List<PostEntity> list = <PostEntity>[];
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

  @override
  Future<DataState<PostEntity>> getPost(
    String id, {
    bool silentUpdate = true,
  }) async {
    try {
      if (silentUpdate) {
        ApiRequestEntity? request = await LocalRequestHistory().request(
          endpoint: '/post/$id',
          duration:
              kDebugMode ? const Duration(days: 1) : const Duration(hours: 1),
        );
        if (request != null) {
          final PostEntity? post = LocalPost().post(id);
          if (post != null) {
            return DataSuccess<PostEntity>(request.encodedData, post);
          }
        }
      }
      //
      //

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: '/post/$id',
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataFailer<PostEntity>(
              result.exception ?? CustomException('something-wrong'.tr()));
        }
        final dynamic item = json.decode(raw);
        final PostEntity post = PostModel.fromJson(item);
        await LocalPost().save(post);
        return DataSuccess<PostEntity>(raw, post);
      } else {
        log('PostRemoteApiImpl.getPost failed: ${result.exception?.message}');
        return DataFailer<PostEntity>(
          result.exception ?? CustomException('something-wrong'.tr()),
        );
      }
    } catch (e) {
      log('PostRemoteApiImpl.getPost catch failed: $e');
      return DataFailer<PostEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> addToCart(AddToCartParam param) async {
    const String endpoint = '/cart/add';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: param.addToCart(),
      );
      if (result is DataSuccess) {
        final GetCartUsecase cartUsecase = GetCartUsecase(locator());
        await cartUsecase('');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'ERROR - PostRemoteApiImpl.addToCart',
          name: 'PostRemoteApiImpl.addToCart - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something-wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.addToCart - catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
