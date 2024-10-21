import '../../domain/entities/message_last_evaluated_key_entity.dart';

class MessageLastEvaluatedKeyModel extends MessageLastEvaluatedKeyEntity {
  MessageLastEvaluatedKeyModel({
    required super.chatID,
    super.createdAt = 'null',
    super.paginationKey,
  });

  factory MessageLastEvaluatedKeyModel.fromMap(
      Map<String, dynamic> map, String chatID) {
    return MessageLastEvaluatedKeyModel(
      chatID: map['chat_id'] ?? chatID,
      paginationKey: map['message_id'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatID,
      'message_id': paginationKey,
      'created_at': createdAt,
    };
  }

  MessageLastEvaluatedKeyModel copyWith({
    String? chatID,
    String? paginationKey,
    String? createdAt,
  }) {
    return MessageLastEvaluatedKeyModel(
      chatID: chatID ?? this.chatID,
      paginationKey: paginationKey ?? this.paginationKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
