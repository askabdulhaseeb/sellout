// import '../../../../../../core/enums/chat/chat_type.dart';
// import '../../../../../attachment/domain/entities/picked_attachment.dart';

// class CreateChatParams {
//   CreateChatParams({
//     required this.recieverId,
//     required this.type,
//     this.businessID,
//     this.attachments,
//     this.groupTitle,
//     this.groupDescription,
//     this.source = 'Application',
//   });

//   final ChatType type;
//   final List<String> recieverId;
//   final String? businessID;
//   final List<PickedAttachment>? attachments;
//   final String? groupTitle;
//   final String? groupDescription;
//   final String source;

//   Map<String, dynamic> toMap() {
//     final Map<String, dynamic> data = {
//       'type': type.json,
//       'receiver_id': recieverId,
//       'source': source,
//       'business_id': businessID,
//     };

//     if (type == ChatType.group) {
//       data['group_title'] = groupTitle;
//       data['group_description'] = groupDescription;
//     }

//     return data;
//   }
// }
