import '../../../chat_dashboard/data/models/message/message_model.dart';
import '../../domain/entities/getted_message_entity.dart';
import 'message_last_evaluated_key.dart';

class GettedMessageModel extends GettedMessageEntity {
  const GettedMessageModel({
    required super.chatID,
    required super.messages,
    required super.lastEvaluatedKey,
  });

  factory GettedMessageModel.fromMap(Map<String, dynamic> map, String chatID) {
    return GettedMessageModel(
      chatID: chatID,
      messages: List<MessageModel>.from((map['messages'] ?? <dynamic>[])
          ?.map((dynamic x) => MessageModel.fromJson(x))),
      lastEvaluatedKey: map['lastEvaluatedKey'] == null
          ? null
          : MessageLastEvaluatedKeyModel.fromMap(
              map['lastEvaluatedKey'], chatID),
    );
  }

  GettedMessageModel copyWith({
    List<MessageModel>? messages,
    MessageLastEvaluatedKeyModel? lastEvaluatedKey,
  }) {
    return GettedMessageModel(
      chatID: chatID,
      messages: messages ?? this.messages,
      lastEvaluatedKey: lastEvaluatedKey ?? this.lastEvaluatedKey,
    );
  }
}
