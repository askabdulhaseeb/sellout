import 'package:hive/hive.dart';
part 'address_entity.g.dart';

@HiveType(typeId: 6)
class AddressEntity {
  AddressEntity({
    required this.city,
    required this.country,
  });

  @HiveField(0)
  final String city;
  @HiveField(1)
  final String country;
}
