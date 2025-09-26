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
      sellerId: fields[1] as String,
      buyerId: fields[2] as String,
      quoteId: fields[3] as String,
      status: fields[4] as StatusType,
      price: fields[5] as double,
      currency: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteDetailEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.serviceEmployee)
      ..writeByte(1)
      ..write(obj.sellerId)
      ..writeByte(2)
      ..write(obj.buyerId)
      ..writeByte(3)
      ..write(obj.quoteId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.currency);
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
