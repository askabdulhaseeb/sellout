import '../../../../domain/entities/chat/participant/invitation_entity.dart';

class InvitationModel extends InvitationEntity {
  InvitationModel({
    required super.uid,
    required super.addedBy,
    required super.invitedAt,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) =>
      InvitationModel(
        uid: json['uid'],
        addedBy: json['added_by'],
        invitedAt: DateTime.parse(json['invited_at']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'added_by': addedBy,
        'invited_at': invitedAt.toIso8601String(),
      };
}
