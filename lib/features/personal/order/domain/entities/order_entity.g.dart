// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderEntityAdapter extends TypeAdapter<OrderEntity> {
  @override
  final typeId = 61;

  @override
  OrderEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderEntity(
      orderId: fields[0] as String,
      buyerId: fields[1] as String,
      sellerId: fields[2] as String,
      postId: fields[3] as String,
      orderStatus: fields[4] as StatusType,
      orderType: fields[5] as String,
      price: (fields[6] as num).toDouble(),
      totalAmount: (fields[7] as num).toDouble(),
      quantity: (fields[8] as num).toInt(),
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      paymentDetail: fields[11] as OrderPaymentDetailEntity,
      shippingAddress: fields[12] as AddressEntity,
      businessId: fields[13] as String,
      size: fields[14] as String?,
      color: fields[15] as String?,
      listId: fields[16] as String?,
      isBusinessOrder: fields[17] as bool?,
      transactionId: fields[18] as String?,
      trackId: fields[19] as String?,
      deliveryPaidBy: fields[20] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderEntity obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.buyerId)
      ..writeByte(2)
      ..write(obj.sellerId)
      ..writeByte(3)
      ..write(obj.postId)
      ..writeByte(4)
      ..write(obj.orderStatus)
      ..writeByte(5)
      ..write(obj.orderType)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.totalAmount)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.paymentDetail)
      ..writeByte(12)
      ..write(obj.shippingAddress)
      ..writeByte(13)
      ..write(obj.businessId)
      ..writeByte(14)
      ..write(obj.size)
      ..writeByte(15)
      ..write(obj.color)
      ..writeByte(16)
      ..write(obj.listId)
      ..writeByte(17)
      ..write(obj.isBusinessOrder)
      ..writeByte(18)
      ..write(obj.transactionId)
      ..writeByte(19)
      ..write(obj.trackId)
      ..writeByte(20)
      ..write(obj.deliveryPaidBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
