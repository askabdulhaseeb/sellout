import '../../../../../../../attachment/data/attchment_model.dart';
import '../../../../domain/entities/chat/group/group_into_entity.dart';
import '../participant/chat_participant_model.dart';
import '../participant/invitation_model.dart';

class GroupInfoModel extends GroupInfoEntity {
  GroupInfoModel({
    required super.description,
    required super.title,
    required super.createdBy,
    required super.invitations,
    required super.imageUrl,
    required super.participants,
  });

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) => GroupInfoModel(
        description: json['description'],
        title: json['title'],
        createdBy: json['created_by'],
        invitations: List<InvitationModel>.from(
            (json['invitations'] ?? <dynamic>[])
                .map((dynamic x) => InvitationModel.fromJson(x))),
        imageUrl: List<AttachmentModel>.from((json['image_url'] ?? <dynamic>[])
            .map((dynamic x) => AttachmentModel.fromJson(x))),
        participants: List<ChatParticipantModel>.from(
            (json['participants'] ?? <dynamic>[])
                .map((dynamic x) => ChatParticipantModel.fromJson(x))),
      );
}
