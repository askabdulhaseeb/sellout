import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/params/report_params.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../../services/get_it.dart';
import '../../../../basket/domain/usecase/cart/get_cart_usecase.dart';
import '../../../../chats/chat/domain/params/post_inquiry_params.dart';
import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/params/add_to_cart_param.dart';
import '../../../domain/params/feed_response_params.dart';
import '../../../domain/params/get_feed_params.dart';
import '../../models/post/post_model.dart';
import '../local/local_post.dart';

abstract interface class PostRemoteApi {
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params);
  Future<DataState<PostEntity>> getPost(
    String id, {
    required bool silentUpdate,
  });
  Future<DataState<bool>> addToCart(AddToCartParam param);
  Future<DataState<bool>> reportPost(ReportParams params);
  Future<DataState<bool>> savePost(String postID);
  Future<DataState<bool>> startInquiryChat(PostInquiryParams param);
}

class PostRemoteApiImpl implements PostRemoteApi {
  @override
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params) async {
    final String endpoint = 'feed?type=${params.type}&key=${params.key}';
    debugPrint('[FeedAPI] Calling endpoint: $endpoint');

    try {
      debugPrint('[FeedAPI] Checking local cache for: $endpoint');
      final ApiRequestEntity? request = await LocalRequestHistory().request(
        endpoint: endpoint,
        duration: Duration.zero,
      );

      String? rawData;

      if (request != null) {
        debugPrint('[FeedAPI] Loaded posts from local cache ✅');
        rawData = request.encodedData;
      } else {
        debugPrint(
          '[FeedAPI] No valid cache found. Fetching from network 🌐...',
        );
        final DataState<String> result = await ApiCall<String>().call(
          endpoint: endpoint,
          requestType: ApiRequestType.get,
          isAuth: false,
        );

        if (result is DataSuccess) {
          rawData = result.data ?? '';
          if (rawData.isEmpty) {
            debugPrint('[FeedAPI] Empty response received ⚠️');
            return DataFailer<GetFeedResponse>(
              result.exception ?? CustomException('something_wrong'.tr()),
            );
          }
        } else {
          debugPrint(
            '[FeedAPI] Network call failed : ${result.exception?.message}',
          );
          return DataFailer<GetFeedResponse>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }
      }

      // ✅ Parse response here directly
      final Map<String, dynamic> jsonMap = json.decode(rawData);
      final List<dynamic> list = jsonMap['response'] ?? <dynamic>[];
      final String? nextPageToken = jsonMap['nextPageToken'];

      final List<PostEntity> posts = list
          .map<PostEntity>((item) => PostModel.fromJson(item))
          .toList();

      debugPrint('[FeedAPI] Next page token: $nextPageToken');

      return DataSuccess<GetFeedResponse>(
        '',
        GetFeedResponse(nextPageToken: nextPageToken, posts: posts),
      );
    } catch (e) {
      debugPrint('[FeedAPI] Exception occurred 💥: $e');
      return DataFailer<GetFeedResponse>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<PostEntity>> getPost(
    String id, {
    required bool silentUpdate,
  }) async {
    try {
      if (silentUpdate) {
        debugPrint('updating post silently: $id');
        ApiRequestEntity? request = await LocalRequestHistory().request(
          endpoint: '/post/$id',
          duration: kDebugMode
              ? const Duration(days: 1)
              : const Duration(hours: 1),
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
        debugPrint('fetched fresh post from backend: $id');

        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataFailer<PostEntity>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }
        final dynamic item = json.decode(raw);
        final PostEntity post = PostModel.fromJson(item);
        await LocalPost().save(post.postID, post);
        return DataSuccess<PostEntity>(raw, post);
      } else {
        AppLog.error(
          '${result.exception?.message} - $id',
          name: 'PostRemoteApiImpl.getPost - else',
          error: result.exception,
        );
        return DataFailer<PostEntity>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        '$e - $id',
        name: 'PostRemoteApiImpl.getPost - catch',
        error: e,
      );
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
          result.exception ?? CustomException('something_wrong'.tr()),
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

  @override
  Future<DataState<bool>> reportPost(ReportParams params) async {
    const String endpoint = '/post/report';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        isAuth: true,
        body: json.encode(params.toPostReportMap()),
      );
      if (result is DataSuccess) {
        AppLog.info(
          result.data ?? '',
          name: 'PostRemoteApiImpl.reportPost - success',
        );
        debugPrint(result.data.toString());
        debugPrint(params.toString());
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'PostRemoteApiImpl.reportPost - else',
          name: 'PostRemoteApiImpl.reportPost - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stk) {
      debugPrint(params.toString());

      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.reportPost - catch',
        error: e,
        stackTrace: stk,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> savePost(String postID) async {
    const String endpoint = 'user/save/post';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        isAuth: true,
        body: json.encode(<String, String>{'post_id': postID}),
      );

      if (result is DataSuccess) {
        AppLog.info(
          'Post save/unsave successful ',
          name: 'PostRemoteApiImpl.savePost - success',
        );
        debugPrint('Post save/unsave successful: postID = $postID');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'Unknown error during save/unsave',
          name: 'PostRemoteApiImpl.savePost - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stk) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.savePost - catch',
        error: e,
        stackTrace: stk,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> startInquiryChat(PostInquiryParams param) async {
    const String endpoint = '/chat/inquiry/start';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toJson()),
      );
      if (result is DataSuccess) {
        AppLog.info(
          'Inquiry chat started successfully',
          name: 'PostRemoteApiImpl.startInquiryChat - success',
        );
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'Failed to start inquiry chat',
          name: 'PostRemoteApiImpl.startInquiryChat - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stk) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.startInquiryChat - catch',
        error: e,
        stackTrace: stk,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }
}
