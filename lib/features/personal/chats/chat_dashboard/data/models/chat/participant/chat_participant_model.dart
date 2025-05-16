import '../../../../../../../../core/enums/chat/chat_participant_role.dart';
import '../../../../domain/entities/chat/participant/chat_participant_entity.dart';

class ChatParticipantModel extends ChatParticipantEntity {
  factory ChatParticipantModel.fromEntity(ChatParticipantEntity entity) {
    return ChatParticipantModel(
      uid: entity.uid,
      joinAt: entity.joinAt,
      role: entity.role,
      source: entity.source,
      chatAt: entity.chatAt,
      addBy: entity.addBy,
      addedBy: entity.addedBy,
    );
  }
  ChatParticipantModel({
    required super.uid,
    required super.joinAt,
    required super.role,
    required super.source,
    required super.chatAt,
    super.addBy,
    super.addedBy,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) =>
      ChatParticipantModel(
        uid: json['uid'],
        joinAt: DateTime.parse(json['join_at']),
        role: ChatParticipantRoleType.fromJson(json['role']),
        addBy: json['add_by'],
        source: json['source'],
        chatAt: DateTime.parse(json['chat_at']),
        addedBy: json['added_by'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'join_at': joinAt.toIso8601String(),
        'role': role.json,
        'add_by': addBy,
        'source': source,
        'chat_At': chatAt.toIso8601String(),
        'added_by': addedBy,
      };
}
