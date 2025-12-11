// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast_delivery_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastDeliveryEntityAdapter extends TypeAdapter<FastDeliveryEntity> {
  @override
  final typeId = 91;

  @override
  FastDeliveryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastDeliveryEntity(
      available: fields[0] as bool?,
      message: fields[1] as String?,
      requested: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FastDeliveryEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.available)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.requested);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastDeliveryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
