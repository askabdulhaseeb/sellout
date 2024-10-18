// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_amount_info_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfferAmountInfoEntityAdapter extends TypeAdapter<OfferAmountInfoEntity> {
  @override
  final int typeId = 27;

  @override
  OfferAmountInfoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfferAmountInfoEntity(
      offer: fields[0] as double?,
      currency: fields[1] as String?,
      isAccepted: fields[2] as bool,
      id: fields[3] as String,
      type: fields[4] as ChatType,
    );
  }

  @override
  void write(BinaryWriter writer, OfferAmountInfoEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.offer)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.isAccepted)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferAmountInfoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
