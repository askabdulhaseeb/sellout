import 'package:hive/hive.dart';

import '../../../../../../../../core/enums/chat/chat_participant_role.dart';

part 'chat_participant_entity.g.dart';

@HiveType(typeId: 11)
class ChatParticipantEntity {
  const ChatParticipantEntity({
    required this.uid,
    required this.joinAt,
    required this.role,
    required this.source,
    required this.chatAt,
    this.addBy,
    this.addedBy,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final DateTime joinAt;
  @HiveField(2)
  final ChatParticipantRoleType role;
  @HiveField(3)
  final String? addBy;
  @HiveField(4)
  final String source;
  @HiveField(5)
  final DateTime chatAt;
  @HiveField(6)
  final String? addedBy;
}
