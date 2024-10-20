import '../../../../../../../core/sources/api_call.dart';
import '../../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../chat_dashboard/domain/entities/messages/message_entity.dart';
import '../../../domain/entities/getted_message_entity.dart';
import '../../models/getted_message_model.dart';
import '../local/local_message.dart';

abstract interface class MessagesRemoteSource {
  Future<DataState<List<MessageEntity>>> getMessages({
    required String chatID,
    required String? key,
    required DateTime createdAt,
  });
  Future<void> sendMessage(MessageEntity msg);
}

class MessagesRemoteSourceImpl implements MessagesRemoteSource {
  @override
  Future<DataState<List<MessageEntity>>> getMessages({
    required String chatID,
    required String? key,
    required DateTime createdAt,
  }) async {
    String endpoint =
        '''/chat/getMessages/$chatID?lastEvaluatedKey={"chat_id":"$chatID","message_id":"$key","created_at":"${createdAt.toIso8601String()}Z"}''';
    final DataState<bool> result = await ApiCall<bool>().call(
      endpoint: endpoint,
      isAuth: true,
      requestType: ApiRequestType.get,
    );

    if (result is DataSuccess) {
      final String raw = result.data ?? '';
      if (raw.isEmpty) {
        return DataSuccess<List<MessageEntity>>(raw, _local(chatID));
      }
      final List<MessageEntity> messages = <MessageEntity>[];
      final dynamic data = json.decode(raw);
      final GettedMessageEntity getted =
          GettedMessageModel.fromMap(data, chatID);
      await LocalChatMessage().save(getted);
      return DataSuccess<List<MessageEntity>>(result.data ?? '', messages);
    } else {
      final List<MessageEntity> megs = _local(chatID);
      return megs.isEmpty
          ? DataSuccess<List<MessageEntity>>(result.data ?? '', megs)
          : DataFailer<List<MessageEntity>>(
              result.exception ?? CustomException('something-wrong'.tr()),
            );
    }
  }

  @override
  Future<void> sendMessage(MessageEntity msg) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  List<MessageEntity> _local(String chatID) {
    return LocalChatMessage().messages(chatID);
  }
}
