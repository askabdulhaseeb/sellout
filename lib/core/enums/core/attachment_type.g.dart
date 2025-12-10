// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentTypeAdapter extends TypeAdapter<AttachmentType> {
  @override
  final typeId = 5;

  @override
  AttachmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttachmentType.image;
      case 1:
        return AttachmentType.video;
      case 2:
        return AttachmentType.audio;
      case 3:
        return AttachmentType.document;
      case 4:
        return AttachmentType.other;
      case 5:
        return AttachmentType.media;
      case 6:
        return AttachmentType.contacts;
      case 7:
        return AttachmentType.location;
      default:
        return AttachmentType.image;
    }
  }

  @override
  void write(BinaryWriter writer, AttachmentType obj) {
    switch (obj) {
      case AttachmentType.image:
        writer.writeByte(0);
      case AttachmentType.video:
        writer.writeByte(1);
      case AttachmentType.audio:
        writer.writeByte(2);
      case AttachmentType.document:
        writer.writeByte(3);
      case AttachmentType.other:
        writer.writeByte(4);
      case AttachmentType.media:
        writer.writeByte(5);
      case AttachmentType.contacts:
        writer.writeByte(6);
      case AttachmentType.location:
        writer.writeByte(7);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
