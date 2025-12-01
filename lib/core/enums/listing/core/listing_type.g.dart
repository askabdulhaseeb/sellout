// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListingTypeAdapter extends TypeAdapter<ListingType> {
  @override
  final typeId = 9;

  @override
  ListingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ListingType.items;
      case 1:
        return ListingType.clothAndFoot;
      case 2:
        return ListingType.vehicle;
      case 3:
        return ListingType.foodAndDrink;
      case 4:
        return ListingType.property;
      case 5:
        return ListingType.pets;
      default:
        return ListingType.items;
    }
  }

  @override
  void write(BinaryWriter writer, ListingType obj) {
    switch (obj) {
      case ListingType.items:
        writer.writeByte(0);
      case ListingType.clothAndFoot:
        writer.writeByte(1);
      case ListingType.vehicle:
        writer.writeByte(2);
      case ListingType.foodAndDrink:
        writer.writeByte(3);
      case ListingType.property:
        writer.writeByte(4);
      case ListingType.pets:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
