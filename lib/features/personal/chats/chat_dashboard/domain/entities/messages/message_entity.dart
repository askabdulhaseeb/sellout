import 'package:hive/hive.dart';

import '../../../../../../../core/enums/message/message_type.dart';
import '../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../post/domain/entities/offer/offer_detail_entity.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';

part 'message_entity.g.dart';

@HiveType(typeId: 13)
class MessageEntity {
  MessageEntity({
    required this.persons,
    required this.fileUrl,
    required this.updatedAt,
    required this.createdAt,
    required this.messageId,
    required this.text,
    required this.displayText,
    required this.sendBy,
    required this.chatId,
    this.visitingDetail,
    this.type,
    this.source,
    this.offerDetail,
  });

  @HiveField(0)
  final List<String> persons;
  @HiveField(1)
  final List<AttachmentEntity> fileUrl;
  @HiveField(2)
  final DateTime updatedAt;
  @HiveField(3)
  VisitingEntity? visitingDetail;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final String messageId;
  @HiveField(6)
  final String text;
  @HiveField(7)
  final MessageType? type;
  @HiveField(8)
  final String displayText;
  @HiveField(9)
  final String sendBy;
  @HiveField(10)
  final String chatId;
  @HiveField(11)
  final String? source;
  @HiveField(12)
  final OfferDetailEntity? offerDetail;

  String? get postImage => offerDetail?.post.imageURL;
  MessageEntity copyWith({
    List<String>? persons,
    List<AttachmentEntity>? fileUrl,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? messageId,
    String? text,
    String? displayText,
    String? sendBy,
    String? chatId,
    VisitingEntity? visitingDetail,
    MessageType? type,
    String? source,
    OfferDetailEntity? offerDetail,
  }) {
    return MessageEntity(
      persons: persons ?? this.persons,
      fileUrl: fileUrl ?? this.fileUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      messageId: messageId ?? this.messageId,
      text: text ?? this.text,
      displayText: displayText ?? this.displayText,
      sendBy: sendBy ?? this.sendBy,
      chatId: chatId ?? this.chatId,
      visitingDetail: visitingDetail ?? this.visitingDetail,
      type: type ?? this.type,
      source: source ?? this.source,
      offerDetail: offerDetail ?? this.offerDetail,
    );
  }
}
