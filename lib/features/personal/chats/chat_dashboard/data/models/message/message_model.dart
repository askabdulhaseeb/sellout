import '../../../../../../../core/enums/message/message_type.dart';
import '../../../../../../../core/extension/string_ext.dart';
import '../../../../../../attachment/data/attchment_model.dart';
import '../../../../../post/data/models/offer/offer_detail_model.dart';
import '../../../../../post/data/models/visit/visiting_model.dart';
import '../../../../quote/data/models/quote_detail_model.dart';
import '../../../domain/entities/messages/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.persons,
    required super.fileUrl,
    required super.updatedAt,
    required super.createdAt,
    required super.messageId,
    required super.text,
    required super.displayText,
    required super.sendBy,
    required super.chatId,
    super.visitingDetail,
    super.type,
    super.source,
    super.offerDetail,
    super.quoteDetail,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final dynamic fileUrl = json['file_url'];
    List<AttachmentModel> fileUrlList = <AttachmentModel>[];
    if (fileUrl != null) {
      if (fileUrl is List) {
        for (dynamic item in fileUrl) {
          fileUrlList.add(AttachmentModel.fromJson(item));
        }
      } else {
        fileUrlList.add(AttachmentModel.fromJson(fileUrl));
      }
    }
    return MessageModel(
      persons: List<String>.from(
          (json['persons'] ?? <dynamic>[]).map((dynamic x) => x)),
      fileUrl: fileUrlList,
      updatedAt:
          (json['updated_at']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      visitingDetail: json['visiting_detail'] == null
          ? null
          : VisitingModel.fromJson(json['visiting_detail']),
      createdAt:
          (json['created_at']?.toString() ?? '').toDateTime() ?? DateTime.now(),
      messageId: json['message_id'],
      text: json['text']?.toString() ?? '',
      type: MessageType.fromJson(json['type']),
      displayText: json['display_text'],
      sendBy: json['send_by'],
      chatId: json['chat_id'],
      source: json['source'] ?? '',
      offerDetail: json['offer_detail'] == null
          ? null
          : OfferDetailModel.fromJson(json['offer_detail']),
      quoteDetail: json['quote_detail'] == null
          ? null
          : QuoteDetailModel.fromMap(json['quote_detail']),
    );
  }
}
