import '../../domain/entities/address_entity.dart';
export '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.addressID,
    required super.phoneNumber,
    required super.recipientName,
    required super.address,
    required super.category,
    required super.postalCode,
    required super.townCity,
    required super.country,
    required super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addressID: json['address_id'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        recipientName: json['recipient_name'] ?? '',
        address: json['address_1'] ?? '',
        category: json['address_category'] ?? '',
        postalCode: json['postal_code'] ?? '',
        townCity: json['town_city'] ?? '',
        country: json['country'] ?? 'UK',
        isDefault: json['is_default'] ?? false,
      );
}
