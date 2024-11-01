import 'dart:developer';

import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../../domain/params/send_message_param.dart';
import '../../models/getted_message_model.dart';
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
        return DataSuccess<GettedMessageEntity>(raw, _local(chatID));
      }
      //
      final dynamic data = json.decode(raw);
      final GettedMessageEntity getted =
          GettedMessageModel.fromMap(data, chatID);
      log('New Message - is Saving');
      await LocalChatMessage().save(getted, chatID);
      return DataSuccess<GettedMessageEntity>(result.data ?? '', getted);
    } else {
      log('New Message - ERROR');
      final GettedMessageEntity? getted = _local(chatID);
      return getted == null
          ? DataSuccess<GettedMessageEntity>(result.data ?? '', getted)
          : DataFailer<GettedMessageEntity>(
              result.exception ?? CustomException('something-wrong'.tr()),
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
        return DataSuccess<bool>(result.data ?? '', true);
      } else {
        return DataFailer<bool>(
          result.exception ?? CustomException('something-wrong'.tr()),
        );
      }
    } catch (e) {
      return DataFailer<bool>(CustomException(e.toString()));
    }
  }

  GettedMessageEntity? _local(String chatID) {
    return LocalChatMessage().entity(chatID);
  }
}
