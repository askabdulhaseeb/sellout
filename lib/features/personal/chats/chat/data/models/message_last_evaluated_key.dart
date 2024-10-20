import '../../../../../../core/extension/datetime_ext.dart';
import '../../../../../../core/extension/string_ext.dart';
import '../../domain/entities/message_last_evaluated_key_entity.dart';

class MessageLastEvaluatedKeyModel extends MessageLastEvaluatedKeyEntity {
  MessageLastEvaluatedKeyModel({
    required super.chatID,
    required super.createdAt,
    super.paginationKey,
  });

  factory MessageLastEvaluatedKeyModel.fromMap(
      Map<String, dynamic> map, String chatID) {
    return MessageLastEvaluatedKeyModel(
      chatID: map['chat_id'] ?? chatID,
      paginationKey: map['message_id'],
      createdAt:
          (map['created_at']?.toString() ?? '').toDateTime() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chat_id': chatID,
      'message_id': paginationKey,
      'created_at': createdAt.zTypeDateTime,
    };
  }

  MessageLastEvaluatedKeyModel copyWith({
    String? chatID,
    String? paginationKey,
    DateTime? createdAt,
  }) {
    return MessageLastEvaluatedKeyModel(
      chatID: chatID ?? this.chatID,
      paginationKey: paginationKey ?? this.paginationKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
