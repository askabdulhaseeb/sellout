// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_offer_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterOfferEnumAdapter extends TypeAdapter<CounterOfferEnum> {
  @override
  final int typeId = 67;

  @override
  CounterOfferEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CounterOfferEnum.seller;
      case 1:
        return CounterOfferEnum.buyer;
      default:
        return CounterOfferEnum.seller;
    }
  }

  @override
  void write(BinaryWriter writer, CounterOfferEnum obj) {
    switch (obj) {
      case CounterOfferEnum.seller:
        writer.writeByte(0);
        break;
      case CounterOfferEnum.buyer:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterOfferEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
