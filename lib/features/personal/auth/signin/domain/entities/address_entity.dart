import 'package:hive/hive.dart';
part 'address_entity.g.dart';

@HiveType(typeId: 6)
class AddressEntity {
  AddressEntity({
    required this.addressID,
    required this.phoneNumber,
    required this.recipientName,
    required this.address,
    required this.category,
    required this.postalCode,
    required this.townCity,
    required this.country,
    required this.isDefault,
  });

  @HiveField(0)
  final String addressID;
  @HiveField(1)
  final String phoneNumber;
  @HiveField(2)
  final String recipientName;
  @HiveField(3)
  final String address;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final String postalCode;
  @HiveField(6)
  final String townCity;
  @HiveField(7)
  final String country;
  @HiveField(8)
  final bool isDefault;
}
