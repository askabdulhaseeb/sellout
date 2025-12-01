// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewEntityAdapter extends TypeAdapter<ReviewEntity> {
  @override
  final typeId = 47;

  @override
  ReviewEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewEntity(
      postID: fields[0] as String?,
      reviewID: fields[1] as String,
      sellerID: fields[2] as String?,
      businessID: fields[3] as String?,
      serviceID: fields[4] as String?,
      rating: (fields[5] as num).toDouble(),
      title: fields[6] as String,
      text: fields[7] as String,
      typeSTR: fields[8] as String,
      reviewBy: fields[9] as String,
      fileUrls: (fields[11] as List).cast<AttachmentEntity>(),
      createdAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.postID)
      ..writeByte(1)
      ..write(obj.reviewID)
      ..writeByte(2)
      ..write(obj.sellerID)
      ..writeByte(3)
      ..write(obj.businessID)
      ..writeByte(4)
      ..write(obj.serviceID)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.text)
      ..writeByte(8)
      ..write(obj.typeSTR)
      ..writeByte(9)
      ..write(obj.reviewBy)
      ..writeByte(11)
      ..write(obj.fileUrls)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
