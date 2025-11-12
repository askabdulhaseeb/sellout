import 'dart:convert';
import '../../domain/entities/address_entity.dart';
import '../../../../../../core/widgets/phone_number/data/sources/local_country.dart';
export '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.addressID,
    required super.phoneNumber,
    required super.recipientName,
    required super.address,
    required super.category,
    required super.postalCode,
    required super.city,
    required super.state,
    required super.country,
    super.isDefault = false,
  });

  factory AddressModel.fromEntity(AddressEntity entity) => AddressModel(
        addressID: entity.addressID,
        phoneNumber: entity.phoneNumber,
        recipientName: entity.recipientName,
        address: entity.address,
        category: entity.category,
        postalCode: entity.postalCode,
        city: entity.city,
        state: entity.state,
        country: entity.country,
        isDefault: entity.isDefault,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) {

 

    return AddressModel(
      addressID: json['address_id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      recipientName: json['recipient_name']?.toString() ?? '',
      address: json['address_1']?.toString() ?? '',
      category: json['address_category']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: LocalCountry().getStateByName(json['state'] ?? ''),
      country:
         LocalCountry().country(json['country']),
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> _addressToJson() => <String, dynamic>{
        'recipient_name': recipientName,
        'address_1': address,
        'city': city,
        'state': state.stateName,
        'phone_number': phoneNumber,
        'postal_code': postalCode,
        'address_category': category,
        'country': country.displayName,
        'is_default': isDefault,
      };

  Map<String, dynamic> toJson() => _addressToJson();
  Map<String, dynamic> toShippingJson() => _addressToJson();

  String toOfferJson() => json.encode(_addressToJson());

  String toCheckoutJson() => json.encode({
        'buyer_address': _addressToJson(),
      });
}
