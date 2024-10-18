import 'package:hive/hive.dart';

import '../../../../../../../core/enums/chat/chat_type.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/entities/offer/offer_amount_info_entity.dart';
import '../messages/message_entity.dart';
import 'group/group_into_entity.dart';
import 'participant/chat_participant_entity.dart';

export '../../../../../../../core/enums/chat/chat_type.dart';
part 'chat_entity.g.dart';

@HiveType(typeId: 10)
class ChatEntity {
  const ChatEntity({
    required this.updatedAt,
    required this.createdAt,
    required this.ids,
    required this.createdBy,
    required this.lastMessage,
    required this.persons,
    required this.chatId,
    required this.type,
    this.productInfo,
    this.participants,
    this.deletedBy,
    this.groupInfo,
  });

  @HiveField(0)
  final DateTime updatedAt;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final List<ChatParticipantEntity>? participants;
  @HiveField(3)
  final List<String> ids;
  @HiveField(4)
  final String createdBy;
  @HiveField(5)
  final MessageEntity? lastMessage;
  @HiveField(6)
  final OfferAmountInfoEntity? productInfo;
  @HiveField(7)
  final List<String> persons;
  @HiveField(8)
  final String chatId;
  @HiveField(9)
  final ChatType type;
  @HiveField(10)
  final List<dynamic>? deletedBy;
  @HiveField(11)
  final GroupInfoEntity? groupInfo;

  String otherPerson() {
    final String meID = LocalAuth.uid ?? '';
    return persons.firstWhere((String e) => e != meID, orElse: () => meID);
  }
}
