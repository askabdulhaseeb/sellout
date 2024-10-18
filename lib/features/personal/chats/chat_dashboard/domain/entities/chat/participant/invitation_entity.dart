import 'package:hive/hive.dart';
part 'invitation_entity.g.dart';

@HiveType(typeId: 30)
class InvitationEntity {
  InvitationEntity({
    required this.uid,
    required this.addedBy,
    required this.invitedAt,
  });

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String addedBy;
  @HiveField(2)
  final DateTime invitedAt;
}
