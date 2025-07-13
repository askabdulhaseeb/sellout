// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../order/domain/entities/order_payment_detail_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderPaymentDetailEntityAdapter
    extends TypeAdapter<OrderPaymentDetailEntity> {
  @override
  final int typeId = 62;

  @override
  OrderPaymentDetailEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderPaymentDetailEntity(
      method: fields[0] as String,
      status: fields[1] as String,
      timestamp: fields[2] as DateTime,
      quantity: fields[3] as int,
      price: fields[4] as double,
      paymentIndentId: fields[5] as String,
      transactionChargeCurrency: fields[6] as String,
      transactionChargePerItem: fields[7] as double,
      sellerId: fields[8] as String,
      postCurrency: fields[9] as String,
      deliveryPrice: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderPaymentDetailEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.method)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.paymentIndentId)
      ..writeByte(6)
      ..write(obj.transactionChargeCurrency)
      ..writeByte(7)
      ..write(obj.transactionChargePerItem)
      ..writeByte(8)
      ..write(obj.sellerId)
      ..writeByte(9)
      ..write(obj.postCurrency)
      ..writeByte(10)
      ..write(obj.deliveryPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderPaymentDetailEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
