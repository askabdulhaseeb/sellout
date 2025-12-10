// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromoEntityAdapter extends TypeAdapter<PromoEntity> {
  @override
  final typeId = 56;

  @override
  PromoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromoEntity(
      promoId: fields[0] as String,
      title: fields[1] as String,
      createdBy: fields[2] as String,
      createdAt: fields[3] as DateTime,
      promoType: fields[4] as String,
      isActive: fields[5] as bool,
      fileUrl: fields[6] as String,
      referenceType: fields[7] as String,
      referenceId: fields[8] as String,
      thumbnailUrl: fields[9] as String?,
      views: (fields[10] as List?)?.cast<dynamic>(),
      price: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PromoEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.promoId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.promoType)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.fileUrl)
      ..writeByte(7)
      ..write(obj.referenceType)
      ..writeByte(8)
      ..write(obj.referenceId)
      ..writeByte(9)
      ..write(obj.thumbnailUrl)
      ..writeByte(10)
      ..write(obj.views)
      ..writeByte(11)
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
