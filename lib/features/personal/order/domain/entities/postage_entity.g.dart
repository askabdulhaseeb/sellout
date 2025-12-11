// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postage_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostageEntityAdapter extends TypeAdapter<PostageEntity> {
  @override
  final typeId = 101;

  @override
  PostageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostageEntity(
      parcel: (fields[0] as Map?)?.cast<String, dynamic>(),
      provider: fields[1] as String?,
      convertedBufferAmount: fields[2] as num?,
      serviceName: fields[3] as String?,
      rateObjectId: fields[4] as String?,
      nativeCurrency: fields[5] as String?,
      convertedCurrency: fields[6] as String?,
      nativeBufferAmount: fields[7] as num?,
      coreAmount: fields[8] as num?,
      shipmentId: fields[9] as String?,
      serviceToken: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PostageEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.parcel)
      ..writeByte(1)
      ..write(obj.provider)
      ..writeByte(2)
      ..write(obj.convertedBufferAmount)
      ..writeByte(3)
      ..write(obj.serviceName)
      ..writeByte(4)
      ..write(obj.rateObjectId)
      ..writeByte(5)
      ..write(obj.nativeCurrency)
      ..writeByte(6)
      ..write(obj.convertedCurrency)
      ..writeByte(7)
      ..write(obj.nativeBufferAmount)
      ..writeByte(8)
      ..write(obj.coreAmount)
      ..writeByte(9)
      ..write(obj.shipmentId)
      ..writeByte(10)
      ..write(obj.serviceToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
