import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../post/data/models/offer/offer_amount_info_model.dart';
import '../../../domain/entities/chat/chat_entity.dart';
import '../../../domain/entities/chat/participant/chat_participant_entity.dart';
import '../message/message_model.dart';
import 'group/group_info_model.dart';
import 'participant/chat_participant_model.dart';
export '../../../domain/entities/chat/chat_entity.dart';

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
    super.pinnedMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        updatedAt: (json['updated_at']?.toString() ?? '').toDateTime() ??
            DateTime.now(),
        createdAt: (json['created_at']?.toString() ?? '').toDateTime() ??
            DateTime.now(),
        participants: json['participants'] == null
            ? <ChatParticipantEntity>[]
            : List<ChatParticipantModel>.from((json['participants'] ?? <dynamic>[])
                .map((dynamic x) => ChatParticipantModel.fromJson(x))),
        ids: List<String>.from(
            (json['ids'] ?? <dynamic>[]).map((dynamic x) => x)),
        createdBy: json['created_by'] ?? json['send_by'] ?? '',
        lastMessage: json['last_message'] == null
            ? null
            : MessageModel.fromMap(json['last_message']),
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
        pinnedMessage: json['pinned_message'] == null
            ? null
            : MessageModel.fromMap(json['pinned_message']));
  }
}
// {
//     "chats": [
//         {
//             "deleted_by": [],
//             "chat_id": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U-e1d86ab4-99af-4a8d-b48b-7f9f716e4c05-PL",
//             "updated_at": "2025-12-09T14:16:06.945Z",
//             "persons": [
//                 "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                 "947bb35a-2395-45f9-ad31-3cd4d25d1bb4-U"
//             ],
//             "created_by": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//             "last_message": {
//                 "persons": [
//                     "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                     "947bb35a-2395-45f9-ad31-3cd4d25d1bb4-U"
//                 ],
//                 "file_url": null,
//                 "updated_at": "2025-12-09T14:16:06.945Z",
//                 "file_status": null,
//                 "created_at": "2025-12-09T14:16:06.945Z",
//                 "message_id": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U-2025-12-09T14:16:06.945Z",
//                 "text": "yes",
//                 "source": "application",
//                 "send_by": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                 "display_text": "yes",
//                 "chat_id": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U-e1d86ab4-99af-4a8d-b48b-7f9f716e4c05-PL"
//             },
//             "product_info": {
//                 "type": "product",
//                 "id": "e1d86ab4-99af-4a8d-b48b-7f9f716e4c05-PL"
//             },
//             "participants": [
//                 {
//                     "uid": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                     "join_at": "2025-12-09T14:15:32.929Z",
//                     "role": "admin",
//                     "source": "Inquiry",
//                     "add_by": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                     "chat_at": "2025-12-09T14:15:32.929Z"
//                 },
//                 {
//                     "uid": "947bb35a-2395-45f9-ad31-3cd4d25d1bb4-U",
//                     "join_at": "2025-12-09T14:15:32.929Z",
//                     "role": "admin",
//                     "source": "Inquiry",
//                     "add_by": "d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                     "chat_at": "2025-12-09T14:15:32.929Z"
//                 }
//             ],
//             "ids": [
//                 "BID:null",
//                 "UID:d7fb48e4-17ac-4fee-a9f4-c7500e0f999f-U",
//                 "PID:e1d86ab4-99af-4a8d-b48b-7f9f716e4c05-PL",
//                 "POST-BID:null"
//             ],
//             "created_at": "2025-12-09T14:15:32.929Z",
//             "type": "product"
//         }
//     ],
//     "deletedChatIds": []
// }