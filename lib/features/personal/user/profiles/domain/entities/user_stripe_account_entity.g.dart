// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stripe_account_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStripeAccountEntityAdapter
    extends TypeAdapter<UserStripeAccountEntity> {
  @override
  final typeId = 45;

  @override
  UserStripeAccountEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStripeAccountEntity(
      payoutEnabled: fields[0] as bool,
      chargesEnabled: fields[1] as bool,
      detailsSubmitted: fields[2] as bool,
      status: fields[3] as StatusType,
    );
  }

  @override
  void write(BinaryWriter writer, UserStripeAccountEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.payoutEnabled)
      ..writeByte(1)
      ..write(obj.chargesEnabled)
      ..writeByte(2)
      ..write(obj.detailsSubmitted)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStripeAccountEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
