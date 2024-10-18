import 'package:hive/hive.dart';

part 'chat_participant_role.g.dart';

@HiveType(typeId: 12)
enum ChatParticipantRoleType {
  @HiveField(0)
  admin('admin', 'admin'),
  @HiveField(1)
  member('member', 'member');

  const ChatParticipantRoleType(this.code, this.json);
  final String code;
  final String json;

  static ChatParticipantRoleType fromJson(String json) =>
      ChatParticipantRoleType.values.firstWhere(
        (ChatParticipantRoleType e) => e.json == json,
        orElse: () => ChatParticipantRoleType.member,
      );
}
