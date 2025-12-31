// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_in_connected_account_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmountInConnectedAccountEntityAdapter
    extends TypeAdapter<AmountInConnectedAccountEntity> {
  @override
  final typeId = 95;

  @override
  AmountInConnectedAccountEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmountInConnectedAccountEntity(
      available: (fields[0] as num).toDouble(),
      currency: fields[1] as String,
      lastSynced: fields[2] as String,
      pending: (fields[3] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, AmountInConnectedAccountEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.available)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.lastSynced)
      ..writeByte(3)
      ..write(obj.pending);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmountInConnectedAccountEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
