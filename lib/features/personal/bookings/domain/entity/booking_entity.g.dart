// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingEntityAdapter extends TypeAdapter<BookingEntity> {
  @override
  final int typeId = 49;

  @override
  BookingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingEntity(
      businessID: fields[0] as String?,
      serviceID: fields[1] as String?,
      bookingID: fields[2] as String?,
      customerID: fields[3] as String,
      employeeID: fields[4] as String,
      trackingID: fields[5] as String?,
      status: fields[6] as StatusType,
      paymentDetail: fields[7] as BookingPaymentDetailEntity?,
      bookedAt: fields[8] as DateTime,
      endAt: fields[9] as DateTime,
      cancelledAt: fields[10] as DateTime?,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      notes: fields[99] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingEntity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.businessID)
      ..writeByte(1)
      ..write(obj.serviceID)
      ..writeByte(2)
      ..write(obj.bookingID)
      ..writeByte(3)
      ..write(obj.customerID)
      ..writeByte(4)
      ..write(obj.employeeID)
      ..writeByte(5)
      ..write(obj.trackingID)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.paymentDetail)
      ..writeByte(8)
      ..write(obj.bookedAt)
      ..writeByte(9)
      ..write(obj.endAt)
      ..writeByte(10)
      ..write(obj.cancelledAt)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.inHiveAt)
      ..writeByte(99)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
