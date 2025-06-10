// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromoEntityAdapter extends TypeAdapter<PromoEntity> {
  @override
  final int typeId = 56;

  @override
  PromoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromoEntity(
      title: fields[0] as String,
      createdBy: fields[1] as String,
      promoId: fields[2] as String,
      promoType: fields[3] as String,
      isActive: fields[4] as bool,
      createdAt: fields[5] as String,
      fileUrl: fields[6] as String,
      views: (fields[8] as List?)?.cast<dynamic>(),
      thumbnailUrl: fields[7] as String?,
      price: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PromoEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.createdBy)
      ..writeByte(2)
      ..write(obj.promoId)
      ..writeByte(3)
      ..write(obj.promoType)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.fileUrl)
      ..writeByte(7)
      ..write(obj.thumbnailUrl)
      ..writeByte(8)
      ..write(obj.views)
      ..writeByte(9)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
