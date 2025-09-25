// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteDetailEntityAdapter extends TypeAdapter<QuoteDetailEntity> {
  @override
  final int typeId = 79;

  @override
  QuoteDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteDetailEntity(
      serviceEmployee: (fields[0] as List).cast<ServiceEmployeeEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuoteDetailEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.serviceEmployee);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
