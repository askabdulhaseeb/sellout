import 'package:hive_ce/hive.dart';
part 'business_address_entity.g.dart';

@HiveType(typeId: 43)
class BusinessAddressEntity {
  BusinessAddressEntity({
    required this.city,
    required this.postalCode,
    required this.firstAddress,
    required this.secondaryAddress,
  });

  @HiveField(0)
  final String city;
  @HiveField(1)
  final int postalCode;
  @HiveField(2)
  final String firstAddress;
  @HiveField(3)
  final String secondaryAddress;
}
