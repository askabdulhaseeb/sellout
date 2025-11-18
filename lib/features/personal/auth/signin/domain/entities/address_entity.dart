import 'package:hive/hive.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/country_entity.dart';
part 'address_entity.g.dart';

@HiveType(typeId: 6)
class AddressEntity {
  AddressEntity({
    required this.addressID,
    required this.phoneNumber,
    required this.recipientName,
    required this.address1,
    required this.address2,
    required this.category,
    required this.postalCode,
    required this.city,
    required this.state,
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
  final String address1;
  @HiveField(4)
  final String address2;
  @HiveField(5)
  final String category;
  @HiveField(6)
  final String postalCode;
  @HiveField(7)
  final String city;
  @HiveField(8)
  final StateEntity? state;
  @HiveField(9)
  final CountryEntity country;
  @HiveField(10)
  final bool isDefault;
}
