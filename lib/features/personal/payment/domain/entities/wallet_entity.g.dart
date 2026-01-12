// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletEntityAdapter extends TypeAdapter<WalletEntity> {
  @override
  final typeId = 92;

  @override
  WalletEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletEntity(
      withdrawableBalance: (fields[0] as num).toDouble(),
      nextReleaseAt: fields[1] as String,
      currency: fields[2] as String,
      createdAt: fields[3] as String,
      canReceive: fields[4] as bool,
      status: fields[5] as String,
      totalEarnings: (fields[6] as num).toDouble(),
      transactionHistory: (fields[7] as List).cast<WalletTransactionEntity>(),
      pendingBalance: (fields[8] as num).toDouble(),
      totalBalance: (fields[9] as num).toDouble(),
      updatedAt: fields[10] as String,
      entityId: fields[11] as String,
      totalRefunded: (fields[12] as num).toDouble(),
      fundsInHold: (fields[13] as List).cast<WalletFundsInHoldEntity>(),
      totalWithdrawn: (fields[14] as num).toDouble(),
      canWithdraw: fields[15] as bool,
      walletId: fields[16] as String,
      amountInConnectedAccount: fields[17] as AmountInConnectedAccountEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, WalletEntity obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.withdrawableBalance)
      ..writeByte(1)
      ..write(obj.nextReleaseAt)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.canReceive)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.totalEarnings)
      ..writeByte(7)
      ..write(obj.transactionHistory)
      ..writeByte(8)
      ..write(obj.pendingBalance)
      ..writeByte(9)
      ..write(obj.totalBalance)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.entityId)
      ..writeByte(12)
      ..write(obj.totalRefunded)
      ..writeByte(13)
      ..write(obj.fundsInHold)
      ..writeByte(14)
      ..write(obj.totalWithdrawn)
      ..writeByte(15)
      ..write(obj.canWithdraw)
      ..writeByte(16)
      ..write(obj.walletId)
      ..writeByte(17)
      ..write(obj.amountInConnectedAccount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
