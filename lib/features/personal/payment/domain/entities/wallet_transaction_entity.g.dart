// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletTransactionEntityAdapter
    extends TypeAdapter<WalletTransactionEntity> {
  @override
  final typeId = 93;

  @override
  WalletTransactionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletTransactionEntity(
      id: fields[0] as String,
      transferAmount: (fields[1] as num).toDouble(),
      payoutAmount: (fields[2] as num).toDouble(),
      currency: fields[3] as String,
      status: fields[4] as StatusType,
      type: fields[5] as String,
      createdAt: fields[6] as String,
      stripeTransferId: fields[7] as String,
      stripePayoutId: fields[8] as String,
      paidAt: fields[9] as String,
      payoutType: fields[10] as String,
      description: fields[11] as String,
      fundId: fields[12] as String,
      releasedAt: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WalletTransactionEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.transferAmount)
      ..writeByte(2)
      ..write(obj.payoutAmount)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.stripeTransferId)
      ..writeByte(8)
      ..write(obj.stripePayoutId)
      ..writeByte(9)
      ..write(obj.paidAt)
      ..writeByte(10)
      ..write(obj.payoutType)
      ..writeByte(11)
      ..write(obj.description)
      ..writeByte(12)
      ..write(obj.fundId)
      ..writeByte(13)
      ..write(obj.releasedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTransactionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
