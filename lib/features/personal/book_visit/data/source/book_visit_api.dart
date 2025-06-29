import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../chats/chat/data/sources/local/local_message.dart';
import '../../../chats/chat/domain/entities/getted_message_entity.dart';
import '../../../chats/chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../post/data/models/visit/visiting_model.dart';
import '../../../post/domain/entities/visit/visiting_entity.dart';
import '../../view/params/book_service_params.dart';
import '../../view/params/book_visit_params.dart';
import '../../view/params/update_visit_params.dart';

abstract interface class BookVisitApi {
  Future<DataState<VisitingEntity>> bookVisit(BookVisitParams params);
  Future<DataState<bool>> bookService(BookServiceParams params);
  // Future<DataState<VisitingEntity>> updateVisitStatus(UpdateVisitParams params);
  Future<DataState<VisitingEntity>> updateVisit(UpdateVisitParams params);
  Future<DataState<List<VisitingEntity>>> getPostVisits(String postID);
}

class BookVisitApiImpl implements BookVisitApi {
  @override
  Future<DataState<VisitingEntity>> bookVisit(BookVisitParams params) async {
    const String endpoint = '/visit/create';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
      );
      if (result is DataSuccess<String>) {
        final Map<String, dynamic> decodedData =
            json.decode(result.data ?? '{}');
        final VisitingEntity? visitingItem = decodedData.containsKey('items')
            ? VisitingModel.fromJson(decodedData['items'])
            : null;
        final String chatId = decodedData['chat_id'] ?? '';
        return DataSuccess<VisitingEntity>(chatId, visitingItem);
      } else {
        AppLog.error(
          result.exception?.message ?? 'ERROR - BookVisitApiImpl.bookVisit',
          name: 'BookVisitApiImpl.bookVisit - failed',
          error: result.exception,
        );
        return DataFailer<VisitingEntity>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitApiImpl.bookVisit - catch',
        error: e,
      );
      return DataFailer<VisitingEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<bool>> bookService(BookServiceParams params) async {
    //this function does not return any booking entity just provide a tracking id with message
    const String endpoint = '/booking/create';
    try {
      final DataState<String> result = await ApiCall<String>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        body: json.encode(params.toMap()),
      );
      if (result is DataSuccess<String>) {
        debugPrint(result.data);
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          result.exception?.message ?? 'ERROR - BookVisitApiImpl.bookService',
          name: 'BookVisitApiImpl.bookService - failed',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitApiImpl.bookService - catch',
        error: e,
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  // @override
  // Future<DataState<VisitingEntity>> updateVisitStatus(
  //     UpdateVisitParams params) async {
  //   const String endpoint = '/visit/update?attribute=status';
  //   try {
  //     final DataState<VisitingEntity> result =
  //         await ApiCall<VisitingEntity>().call(
  //       endpoint: endpoint,
  //       requestType: ApiRequestType.patch,
  //       body: json.encode(params.tocancelvisit()),
  //     );
  //     if (result is DataSuccess) {
  //       debugPrint(result.data);
  //       return DataSuccess<VisitingEntity>(result.data ?? '', result.entity);
  //     } else {
  //       debugPrint('${params.tocancelvisit()} ');
  //       AppLog.error(
  //         result.exception?.message ?? 'something_wrong'.tr(),
  //         name: 'BookVisitApiImpl.CancelVisit - Else',
  //       );
  //       return DataFailer<VisitingEntity>(
  //           CustomException('Failed to cancel visit. Please try again.'));
  //     }
  //   } catch (e, stc) {
  //     debugPrint('${params.tocancelvisit()} ');
  //     AppLog.error(
  //       e.toString(),
  //       name: 'BookVisitApiImpl.CancelVisit - catch $stc',
  //       error: e,
  //     );
  //     return DataFailer<VisitingEntity>(CustomException(e.toString()));
  //   }
  // }

  @override
  Future<DataState<VisitingEntity>> updateVisit(
      UpdateVisitParams params) async {
    String endpoint = '/visit/update?attribute=${params.query}';
    try {
      final DataState<VisitingEntity> result =
          await ApiCall<VisitingEntity>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.patch,
        body: json.encode(params.toupdatevisit()),
      );

      debugPrint('API RESULT DATA: ${result.data}');

      if (result is DataSuccess) {
        final Map<String, dynamic> map = jsonDecode(result.data ?? '');
        final Map<String, dynamic> updatedVisiting = map['result'];
        final VisitingEntity visitingEntity =
            VisitingModel.fromJson(updatedVisiting);

        await _updateVisitingInLocalChat(params.chatId ?? '', visitingEntity);

        return DataSuccess<VisitingEntity>(result.data ?? '', result.entity);
      } else {
        debugPrint('Update payload: ${params.toupdatevisit()}');
        AppLog.error(
          result.exception?.message ?? 'something_wrong'.tr(),
          name: 'BookVisitApiImpl.UpdateVisit - Else',
        );
        return DataFailer<VisitingEntity>(
          CustomException('Failed to update visit. Please try again.'),
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'BookVisitApiImpl.UpdateVisit - catch',
        error: e,
      );
      return DataFailer<VisitingEntity>(CustomException(e.toString()));
    }
  }

  @override
  Future<DataState<List<VisitingEntity>>> getPostVisits(String postID) async {
    final String endpoint = '/visit/query?post_id=$postID';

    try {
      final DataState<bool> result = await ApiCall<bool>().call(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
      );

      if (result is DataSuccess<bool>) {
        final String raw = result.data ?? '';
        debugPrint(result.data);
        final dynamic usable = json.decode(raw);
        final List<dynamic> rawList = usable['items'] ?? <dynamic>[];
        final List<VisitingEntity> list =
            rawList.map((item) => VisitingModel.fromJson(item)).toList();
        return DataSuccess<List<VisitingEntity>>('Success', list);
      } else {
        AppLog.error('Failed to fetch visits', name: 'getPostVisits');
        return DataFailer<List<VisitingEntity>>(
          CustomException('Failed to fetch visits'),
        );
      }
    } catch (e, stack) {
      AppLog.error(
        e.toString(),
        name: 'getPostVisits',
        error: e,
        stackTrace: stack,
      );
      return DataFailer<List<VisitingEntity>>(
        CustomException('Exception occurred: ${e.toString()}'),
      );
    }
  }

  Future<void> _updateVisitingInLocalChat(
      String chatId, VisitingEntity visitingEntity) async {
    final LocalChatMessage localChat = LocalChatMessage();
    final GettedMessageEntity? getted = localChat.entity(chatId);

    if (getted == null) {
      debugPrint(
          '⚠️ No existing GettedMessageEntity found for chatId: $chatId');
      return;
    }

    final List<MessageEntity> updatedMessages = getted.messages.map((msg) {
      if (msg.visitingDetail?.visitingID == visitingEntity.visitingID) {
        debugPrint(
            '🔄 Updating visitingID: ${visitingEntity.visitingID} with new status: ${visitingEntity.status}');
        return msg.copyWith(visitingDetail: visitingEntity);
      }
      return msg;
    }).toList();

    final GettedMessageEntity updatedGetted = GettedMessageEntity(
      chatID: chatId,
      messages: updatedMessages,
      lastEvaluatedKey: getted.lastEvaluatedKey,
    );

    // ✅ Call your clean update method
    await localChat.update(updatedGetted, chatId);

    debugPrint(
        '✅ Successfully replaced GettedMessageEntity for chatId: $chatId');

    // Optional verify
    final GettedMessageEntity? stored = localChat.entity(chatId);
    if (stored != null) {
      for (final msg in stored.messages) {
        debugPrint(
            '📌 Stored visitingID: ${msg.visitingDetail?.visitingID}, status: ${msg.visitingDetail?.status}');
      }
    } else {
      debugPrint('❌ Failed to retrieve stored data for chatId: $chatId');
    }
  }
}
