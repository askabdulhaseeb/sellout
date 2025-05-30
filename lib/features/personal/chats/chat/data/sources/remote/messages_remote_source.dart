import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../../chat_dashboard/data/models/message/message_model.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../../domain/params/send_message_param.dart';
import '../../models/getted_message_model.dart';
import '../../models/message_last_evaluated_key.dart';
import '../local/local_message.dart';

abstract interface class MessagesRemoteSource {
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  });
  Future<DataState<bool>> sendMessage(SendMessageParam msg);
}

class MessagesRemoteSourceImpl implements MessagesRemoteSource {
  @override
  Future<DataState<GettedMessageEntity>> getMessages({
    required String chatID,
    required String? key,
    required String createdAt,
  }) async {
    String endpoint =
        '''/chat/getMessages/$chatID?lastEvaluatedKey={"chat_id":"$chatID","message_id":"$key","created_at":"$createdAt"}''';
    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: endpoint,
      isAuth: true,
      requestType: ApiRequestType.get,
    );

    if (result is DataSuccess) {
      final String raw = result.data ?? '';
      if (raw.isEmpty) {
        AppLog.info(
          'New Message - Empty',
          name: 'MessagesRemoteSourceImpl.getMessages - if',
        );
        return DataSuccess<GettedMessageEntity>(raw, _local(chatID));
      }
      //
      final dynamic data = json.decode(raw);
      final GettedMessageEntity getted =
          GettedMessageModel.fromMap(data, chatID);
      await LocalChatMessage().save(getted, chatID);
      return DataSuccess<GettedMessageEntity>(result.data ?? '', getted);
    } else {
      AppLog.error(
        'New Message - ERROR',
        name: 'MessagesRemoteSourceImpl.getMessages - else',
        error: result.exception,
      );
      final GettedMessageEntity? getted = _local(chatID);
      return getted == null
          ? DataSuccess<GettedMessageEntity>(result.data ?? '', getted)
          : DataFailer<GettedMessageEntity>(
              result.exception ?? CustomException('something_wrong'.tr()),
            );
    }
  }

  @override
  Future<DataState<bool>> sendMessage(SendMessageParam msg) async {
    try {
      const String endpoint = '/chat/message/send';
      final Map<String, String> body = msg.fieldMap();
      final DataState<bool> result = await ApiCall<bool>().callFormData(
        endpoint: endpoint,
        requestType: ApiRequestType.post,
        fieldsMap: body,
        attachments: msg.files,
        isConnectType: false,
      );
      if (result is DataSuccess) {
        debugPrint('New Message - Success: ${result.data}');
        final Map<String, dynamic> responseData = jsonDecode(result.data ?? '');
        final Map<String, dynamic> data = responseData['items'];
        final MessageModel newMsg = MessageModel.fromJson(data);
        final String chatId = data['chat_id'];
        final Box<GettedMessageEntity> box =
            Hive.box<GettedMessageEntity>(AppStrings.localChatMessagesBox);
        // Check if entity exists
        final GettedMessageEntity existing =
            box.values.firstWhere((GettedMessageEntity e) => e.chatID == chatId,
                orElse: () => GettedMessageEntity(
                      chatID: chatId,
                      messages: <MessageModel>[],
                      lastEvaluatedKey: MessageLastEvaluatedKeyModel(
                          chatID: data['chat_id'],
                          createdAt: data['created_at'],
                          paginationKey: data['message_id']),
                    ));

        existing.messages.add(newMsg);

        if (box.containsKey(existing.chatID)) {
          await box.put(existing.chatID, existing);
        } else {
          await box.add(existing);
        }
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        AppLog.error(
          'New Message - ERROR',
          name: 'MessagesRemoteSourceImpl.sendMessage - else',
          error: result.exception,
        );
        return DataFailer<bool>(
          result.exception ?? CustomException('something_wrong'.tr()),
        );
      }
    } catch (e) {
      AppLog.error(
        'New Message - ERROR',
        name: 'MessagesRemoteSourceImpl.sendMessage - catch',
        error: CustomException(e.toString()),
      );
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  GettedMessageEntity? _local(String chatID) {
    return LocalChatMessage().entity(chatID);
  }
}
