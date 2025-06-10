import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../core/sources/local/local_request_history.dart';
import '../../../../../../services/get_it.dart';
import '../../../../cart/domain/usecase/cart/get_cart_usecase.dart';
import '../../../../chats/chat/data/sources/local/local_message.dart';
import '../../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/params/add_to_cart_param.dart';
import '../../../domain/params/create_offer_params.dart';
import '../../../domain/params/update_offer_params.dart';
import '../../models/post_model.dart';
import '../local/local_post.dart';

abstract interface class PostRemoteApi {
  Future<DataState<List<PostEntity>>> getFeed();
  Future<DataState<PostEntity>> getPost(String id);
  Future<DataState<bool>> addToCart(AddToCartParam param);
  Future<DataState<bool>> createOffer(CreateOfferparams param);
  Future<DataState<bool>> updateOffer(UpdateOfferParams param);

  // Future<DataState<bool>> updateOfferStatus(UpdateOfferParams param);
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
        // AppLog.info(
        //   'Post length: Lenght: ${list.length}',
        //   name: 'PostRemoteApiImpl.getFeed - local if',
        // );
        if (list.isNotEmpty) {
          return DataSuccess<List<PostEntity>>(request.encodedData, list);
        }
      }

      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.get,
        isAuth: false,
      );

      if (result is DataSuccess) {
        final String raw = result.data ?? '';
        if (raw.isEmpty) {
          return DataFailer<List<PostEntity>>(
              result.exception ?? CustomException('something_wrong'.tr()));
        }
        final List<dynamic> listt = json.decode(raw)['response'];
        AppLog.info(
          'Post length: Lenght: ${listt.length}',
          name: 'PostRemoteApiImpl.getFeed - if',
        );
        final List<PostEntity> list = <PostEntity>[];
        for (final dynamic item in listt) {
          final PostEntity post = PostModel.fromJson(item);
          await LocalPost().save(post);
          list.add(post);
        }
        return DataSuccess<List<PostEntity>>(raw, list);
      } else {
        AppLog.error(
          '${result.exception?.message}',
          name: 'PostRemoteApiImpl.getFeed - else',
          error: result.exception,
        );
        return DataFailer<List<PostEntity>>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'PostRemoteApiImpl.getFeed - catch',
        error: e,
      );
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

      if (result is DataSuccess) {
        debugPrint(result.data);
        debugPrint(param.toString());
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
          name: 'PostRemoteApiImpl.updateOffer - failed',
          error: result.exception,
        );
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
