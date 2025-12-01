import 'package:hive_ce/hive.dart';

import '../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../participant/chat_participant_entity.dart';
import '../participant/invitation_entity.dart';

part 'group_into_entity.g.dart';

@HiveType(typeId: 29)
class GroupInfoEntity {
  const GroupInfoEntity({
    required this.description,
    required this.title,
    required this.createdBy,
    required this.invitations,
    required this.imageUrl,
    required this.participants,
  });

  @HiveField(0)
  final String description;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String createdBy;
  @HiveField(3)
  final List<InvitationEntity> invitations;
  @HiveField(4)
  final List<AttachmentEntity> imageUrl;
  @HiveField(5)
  final List<ChatParticipantEntity> participants;

  String? get groupThumbnailURL => imageUrl.isEmpty ? null : imageUrl.first.url;
}
