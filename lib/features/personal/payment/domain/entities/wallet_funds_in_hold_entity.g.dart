// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_funds_in_hold_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletFundsInHoldEntityAdapter
    extends TypeAdapter<WalletFundsInHoldEntity> {
  @override
  final typeId = 94;

  @override
  WalletFundsInHoldEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletFundsInHoldEntity(
      transactionId: fields[0] as String,
      amount: (fields[1] as num).toDouble(),
      postId: fields[2] as String,
      releaseAt: fields[3] as String,
      fundId: fields[4] as String,
      currency: fields[5] as String,
      orderId: fields[6] as String,
      status: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WalletFundsInHoldEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.transactionId)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.postId)
      ..writeByte(3)
      ..write(obj.releaseAt)
      ..writeByte(4)
      ..write(obj.fundId)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.orderId)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletFundsInHoldEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
