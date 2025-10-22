// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_cloth_foot_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostClothFootEntityAdapter extends TypeAdapter<PostClothFootEntity> {
  @override
  final int typeId = 68;

  @override
  PostClothFootEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostClothFootEntity(
      sizeColors: (fields[71] as List).cast<SizeColorEntity>(),
      sizeChartUrl: fields[60] as AttachmentEntity?,
      type: fields[61] as String?,
      brand: fields[72] as String?,
      address: fields[73] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostClothFootEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(71)
      ..write(obj.sizeColors)
      ..writeByte(60)
      ..write(obj.sizeChartUrl)
      ..writeByte(61)
      ..write(obj.type)
      ..writeByte(72)
      ..write(obj.brand)
      ..writeByte(73)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostClothFootEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
