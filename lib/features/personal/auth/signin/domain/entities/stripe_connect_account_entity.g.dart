// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../stripe/domain/entities/stripe_connect_account_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StripeConnectAccountEntityAdapter
    extends TypeAdapter<StripeConnectAccountEntity> {
  @override
  final typeId = 88;

  @override
  StripeConnectAccountEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StripeConnectAccountEntity(
      payoutsEnabled: fields[0] as bool,
      id: fields[1] as String,
      chargesEnabled: fields[2] as bool,
      detailsSubmitted: fields[3] as bool,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StripeConnectAccountEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.payoutsEnabled)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.chargesEnabled)
      ..writeByte(3)
      ..write(obj.detailsSubmitted)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StripeConnectAccountEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
