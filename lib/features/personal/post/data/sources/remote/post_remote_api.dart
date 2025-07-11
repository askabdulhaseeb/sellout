import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/params/report_params.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../../services/get_it.dart';
import '../../../../cart/domain/usecase/cart/get_cart_usecase.dart';
import '../../../../chats/chat/data/sources/local/local_message.dart';
import '../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/params/add_to_cart_param.dart';
import '../../../domain/params/create_offer_params.dart';
import '../../../domain/params/feed_response_params.dart';
import '../../../domain/params/get_feed_params.dart';
import '../../../domain/params/offer_payment_params.dart';
import '../../../domain/params/update_offer_params.dart';
import '../../models/post_model.dart';
import '../local/local_post.dart';

abstract interface class PostRemoteApi {
  Future<DataState<GetFeedResponse>> getFeed(GetFeedParams params);
  Future<DataState<PostEntity>> getPost(String id);
  Future<DataState<bool>> addToCart(AddToCartParam param);
  Future<DataState<bool>> createOffer(CreateOfferparams param);
  Future<DataState<bool>> updateOffer(UpdateOfferParams param);
  Future<DataState<bool>> reportPost(ReportParams params);
  Future<DataState<bool>> savePost(String postID);
  Future<DataState<String>> offerPayment(OfferPaymentParams param);
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
            '[FeedAPI] No valid cache found. Fetching from network 🌐...');
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
              '[FeedAPI] Network call failed ❌: ${result.exception?.message}');
          return DataFailer<GetFeedResponse>(
            result.exception ?? CustomException('something_wrong'.tr()),
          );
        }
      }

      // ✅ Parse response here directly
      final Map<String, dynamic> jsonMap = json.decode(rawData);
      final List<dynamic> list = jsonMap['response'] ?? <dynamic>[];
      final String? nextPageToken = jsonMap['nextPageToken'];

      final List<PostEntity> posts =
          list.map<PostEntity>((item) => PostModel.fromJson(item)).toList();

      debugPrint('[FeedAPI] Next page token: $nextPageToken');

      return DataSuccess<GetFeedResponse>(
        '',
        GetFeedResponse(
          nextPageToken: nextPageToken,
          posts: posts,
        ),
      );
    } catch (e) {
      debugPrint('[FeedAPI] Exception occurred 💥: $e');
      return DataFailer<GetFeedResponse>(
        CustomException(e.toString()),
      );
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
              result.exception ?? CustomException('something_wrong'.tr()));
        }
        final dynamic item = json.decode(raw);
        final PostEntity post = PostModel.fromJson(item);
        await LocalPost().save(post);
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
  Future<DataState<bool>> createOffer(CreateOfferparams param) async {
    const String endpoint = '/offers/create';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );
      if (result is DataSuccess) {
        final Map<String, dynamic> data = jsonDecode(result.data ?? '');
        final String chatID = data['chat_id'];
        return DataSuccess<bool>(chatID, true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'ERROR - PostRemoteApiImpl.createOffer',
          name: 'PostRemoteApiImpl.createOffer - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.createOffer - catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> updateOffer(UpdateOfferParams param) async {
    String endpoint = '/offers/update/${param.offerId}';
    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        isAuth: true,
        body: json.encode(param.toMap()),
      );
      debugPrint('updatiing offer params:${param.toMap()}');
      if (result is DataSuccess) {
        debugPrint('updated offer data:${result.data}');
        Map<String, dynamic> mapdata = jsonDecode(result.data!);
        String offerStatus = mapdata['updatedAttributes']['offer_status'];
        int offerAmount = mapdata['updatedAttributes']['offer_amount'];
        MessageEntity message = LocalChatMessage()
            .messages(param.chatID)
            .firstWhere((MessageEntity element) =>
                element.messageId == param.messageId);
        message.offerDetail?.offerPrice = offerAmount;
        message.offerDetail!.offerStatus = offerStatus;
        return DataSuccess<bool>(result.data!, true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'PostRemoteApiImpl.updateOffer - else',
          name: 'PostRemoteApiImpl.updateOffer - else',
          error: result.exception?.reason,
        );
        debugPrint('updated offer params:${result.data}');

        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      debugPrint(param.toString());
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.updateOffer - catch',
        error: e,
        stackTrace: stc,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<String>> offerPayment(OfferPaymentParams param) async {
    const String endpoint = '/payment/offer';

    try {
      debugPrint('➡️ Sending Offer Payment Request...');
      debugPrint('📦 Params: ${param.toMap()}');

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        isAuth: true,
        body: json.encode(param.toMap()),
      );

      if (result is DataSuccess) {
        debugPrint('✅ Offer payment success: ${result.data}');
        final Map<String, dynamic> data = jsonDecode(result.data ?? '');
        final String clientSecret = data['clientSecret'];
        return DataSuccess<String>(result.data!, clientSecret);
      } else {
        debugPrint('❌ Offer payment failed at response stage');
        AppLog.error(
          result.exception?.message ?? 'Unknown error during offer payment',
          name: 'PostRemoteApiImpl.offerPayment - else',
          error: result.exception,
        );

        return DataFailer<String>(
          CustomException(result.exception?.message ?? 'something_wrong'.tr()),
        );
      }
    } catch (e, stc) {
      debugPrint('🔥 Exception during offer payment');
      debugPrint('❗ Params causing issue: ${param.toMap()}');
      debugPrint('❗ Error: $e');

      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.offerPayment - catch',
        error: e,
        stackTrace: stc,
      );

      return DataFailer<String>(
        CustomException('something_wrong'.tr()),
      );
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
          'Post report successful',
          name: 'PostRemoteApiImpl.reportPost - success',
        );
        debugPrint('Post report successful: postID = $postID');
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'Unknown error during report',
          name: 'PostRemoteApiImpl.reportPost - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e, stk) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.reportPost - catch',
        error: e,
        stackTrace: stk,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  // @override
  // Future<DataState<bool>> updateOfferStatus(UpdateOfferParams param) async {
  //   String endpoint = '/offers/update/offerStatus/${param.offerId}';

  //   try {
  //     final DataState<bool> result = await ApiCall<bool>().call(
  //       endpoint: endpoint,
  //       requestType: ApiRequestType.patch,
  //       isAuth: true,
  //       body: json.encode(param.updateStatus()),
  //     );

  //     if (result is DataSuccess) {
  //       // ✅ Fetch the existing entity from Hive
  //       Map<String, dynamic> data = jsonDecode(result.data!);
  //       final String dataStatus = data['updatedAttributes']['offer_status'];
  //       final GettedMessageEntity? oldEntity =
  //           LocalChatMessage().entity(param.offerId);
  //       if (oldEntity != null) {
  //         final List<MessageEntity> updatedMessages =
  //             oldEntity.messages.map((MessageEntity msg) {
  //           if (msg.offerDetail!.offerStatus == param.messageId) {
  //             msg.offerDetail!.offerStatus = dataStatus;
  //           }
  //           return msg;
  //         }).toList();
  //         await LocalChatMessage().save(
  //           GettedMessageEntity(
  //             chatID: oldEntity.chatID,
  //             messages: updatedMessages,
  //             lastEvaluatedKey: oldEntity.lastEvaluatedKey,
  //           ),
  //           param.offerId,
  //         );
  //       }
  //       LocalChatMessage().refresh();
  //       return DataSuccess<bool>(result.data!, true);
  //     } else {
  //       return DataFailer<bool>(
  //         result.exception ?? CustomException('something_wrong'.tr()),
  //       );
  //     }
  //   } catch (e) {
  //     return DataFailer<bool>(CustomException(e.toString()));
  //   }
  // }
}
