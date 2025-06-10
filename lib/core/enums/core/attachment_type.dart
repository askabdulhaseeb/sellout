import 'package:hive/hive.dart';
import 'package:photo_manager/photo_manager.dart';

part 'attachment_type.g.dart';

@HiveType(typeId: 5)
enum AttachmentType {
  @HiveField(0)
  image('image', 'image'),
  @HiveField(1)
  video('video', 'video'),
  @HiveField(2)
  audio('audio', 'audio'),
  @HiveField(3)
  document('document', 'document'),
  @HiveField(4)
  other('other', 'other'),
  @HiveField(5)
  media('media', 'media'),
  @HiveField(6)
  contacts('contacts', 'contacts'),
   @HiveField(7)
  location('location', 'location');

  const AttachmentType(this.json, this.title);

  final String json;
  final String title;

  static AttachmentType fromString(String? value) {
    if (value == null) return AttachmentType.other;
    switch (value) {
      case 'image':
        return AttachmentType.image;
      case 'video':
        return AttachmentType.video;
      case 'audio':
        return AttachmentType.audio;
      case 'document':
        return AttachmentType.document;
        case 'contacts':
        return AttachmentType.contacts;
        case 'location':
        return AttachmentType.location;
      default:
        return AttachmentType.other;
    }
  }

  RequestType get requestType {
    switch (this) {
      case AttachmentType.image:
        return RequestType.image;
      case AttachmentType.video:
        return RequestType.video;
      case AttachmentType.audio:
        return RequestType.audio;
      case AttachmentType.document:
        return RequestType.all;
      default:
        return RequestType.all;
    }
  }
}
