// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackageDetailEntityAdapter extends TypeAdapter<PackageDetailEntity> {
  @override
  final int typeId = 75;

  @override
  PackageDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackageDetailEntity(
      length: fields[0] as String,
      width: fields[1] as String,
      weight: fields[2] as String,
      height: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PackageDetailEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.length)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
