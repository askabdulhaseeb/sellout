// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_payment_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingPaymentDetailEntityAdapter
    extends TypeAdapter<BookingPaymentDetailEntity> {
  @override
  final typeId = 50;

  @override
  BookingPaymentDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingPaymentDetailEntity(
      transactionID: fields[0] as String?,
      status: fields[1] as StatusType?,
      updatedAt: fields[2] as DateTime?,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BookingPaymentDetailEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.transactionID)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPaymentDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
