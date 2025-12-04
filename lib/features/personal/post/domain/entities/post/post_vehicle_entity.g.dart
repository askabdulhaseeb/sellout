// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_vehicle_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostVehicleEntityAdapter extends TypeAdapter<PostVehicleEntity> {
  @override
  final typeId = 69;

  @override
  PostVehicleEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostVehicleEntity(
      year: (fields[0] as num?)?.toInt(),
      doors: (fields[1] as num?)?.toInt(),
      seats: (fields[2] as num?)?.toInt(),
      mileage: (fields[3] as num?)?.toInt(),
      make: fields[4] as String?,
      model: fields[5] as String?,
      bodyType: fields[6] as String?,
      emission: fields[7] as String?,
      fuelType: fields[8] as String?,
      engineSize: (fields[9] as num?)?.toDouble(),
      mileageUnit: fields[10] as String?,
      transmission: fields[11] as String?,
      interiorColor: fields[12] as ColorOptionEntity?,
      exteriorColor: fields[13] as ColorOptionEntity?,
      vehiclesCategory: fields[14] as String?,
      address: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostVehicleEntity obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.doors)
      ..writeByte(2)
      ..write(obj.seats)
      ..writeByte(3)
      ..write(obj.mileage)
      ..writeByte(4)
      ..write(obj.make)
      ..writeByte(5)
      ..write(obj.model)
      ..writeByte(6)
      ..write(obj.bodyType)
      ..writeByte(7)
      ..write(obj.emission)
      ..writeByte(8)
      ..write(obj.fuelType)
      ..writeByte(9)
      ..write(obj.engineSize)
      ..writeByte(10)
      ..write(obj.mileageUnit)
      ..writeByte(11)
      ..write(obj.transmission)
      ..writeByte(12)
      ..write(obj.interiorColor)
      ..writeByte(13)
      ..write(obj.exteriorColor)
      ..writeByte(14)
      ..write(obj.vehiclesCategory)
      ..writeByte(15)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostVehicleEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
