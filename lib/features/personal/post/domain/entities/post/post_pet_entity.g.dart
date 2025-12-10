// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_pet_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostPetEntityAdapter extends TypeAdapter<PostPetEntity> {
  @override
  final typeId = 70;

  @override
  PostPetEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostPetEntity(
      age: fields[0] as String?,
      breed: fields[1] as String?,
      healthChecked: fields[2] as bool?,
      petsCategory: fields[3] as String?,
      readyToLeave: fields[4] as String?,
      wormAndFleaTreated: fields[5] as bool?,
      vaccinationUpToDate: fields[6] as bool?,
      address: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostPetEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.breed)
      ..writeByte(2)
      ..write(obj.healthChecked)
      ..writeByte(3)
      ..write(obj.petsCategory)
      ..writeByte(4)
      ..write(obj.readyToLeave)
      ..writeByte(5)
      ..write(obj.wormAndFleaTreated)
      ..writeByte(6)
      ..write(obj.vaccinationUpToDate)
      ..writeByte(7)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostPetEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
