import '../../../../../../../core/enums/chat/chat_type.dart';
import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../post/data/models/offer/offer_amount_info_model.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import '../../../domain/entities/chat/participant/chat_participant_entity.dart';
import '../message/message_model.dart';
import 'group/group_info_model.dart';
import 'participant/chat_participant_model.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.updatedAt,
    required super.createdAt,
    required super.ids,
    required super.createdBy,
    required super.lastMessage,
    required super.persons,
    required super.chatId,
    required super.type,
    super.productInfo,
    super.participants,
    super.deletedBy,
    super.groupInfo,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      updatedAt:
          (json['updated_at']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      createdAt:
          (json['created_at']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      participants: json['participants'] == null
          ? <ChatParticipantEntity>[]
          : List<ChatParticipantModel>.from(
              (json['participants'] ?? <dynamic>[])
                  .map((dynamic x) => ChatParticipantModel.fromJson(x))),
      ids:
          List<String>.from((json['ids'] ?? <dynamic>[]).map((dynamic x) => x)),
      createdBy: json['created_by'],
      lastMessage: json['last_message'] == null
          ? null
          : MessageModel.fromJson(json['last_message']),
      productInfo: json['product_info'] == null
          ? null
          : OfferAmountInfoModel.fromJson(json['product_info']),
      persons: List<String>.from(
          (json['persons'] ?? <dynamic>[]).map((dynamic x) => x)),
      chatId: json['chat_id'],
      type: ChatType.fromJson(json['type']),
      deletedBy: json['deleted_by'] == null
          ? <dynamic>[]
          : List<dynamic>.from(
              (json['deleted_by'] ?? <dynamic>[]).map((dynamic x) => x)),
      groupInfo: json['group_info'] == null
          ? null
          : GroupInfoModel.fromJson(json['group_info']),
    );
  }
}
