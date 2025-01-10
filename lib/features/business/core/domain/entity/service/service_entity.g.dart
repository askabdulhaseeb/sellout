// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceEntityAdapter extends TypeAdapter<ServiceEntity> {
  @override
  final int typeId = 46;

  @override
  ServiceEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceEntity(
      businessID: fields[0] as String,
      serviceID: fields[1] as String,
      name: fields[2] as String,
      description: fields[19] as String,
      employeesID: (fields[3] as List).cast<String>(),
      employees: (fields[4] as List).cast<BusinessEmployeeEntity>(),
      currency: fields[5] as String,
      isMobileService: fields[6] as bool,
      startAt: fields[7] as bool,
      category: fields[8] as String,
      model: fields[9] as String,
      type: fields[10] as String,
      price: fields[11] as double,
      listOfReviews: (fields[12] as List).cast<double>(),
      time: fields[13] as int,
      createdAt: fields[14] as DateTime,
      attachments: fields[15] == null
          ? []
          : (fields[15] as List).cast<AttachmentEntity>(),
      excluded: fields[17] as String,
      included: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceEntity obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.businessID)
      ..writeByte(1)
      ..write(obj.serviceID)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.employeesID)
      ..writeByte(4)
      ..write(obj.employees)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.isMobileService)
      ..writeByte(7)
      ..write(obj.startAt)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.model)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.price)
      ..writeByte(12)
      ..write(obj.listOfReviews)
      ..writeByte(13)
      ..write(obj.time)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.attachments)
      ..writeByte(16)
      ..write(obj.inHiveAt)
      ..writeByte(17)
      ..write(obj.excluded)
      ..writeByte(18)
      ..write(obj.included)
      ..writeByte(19)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
