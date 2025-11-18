import 'dart:convert';
import '../../domain/entities/address_entity.dart';
import '../../../../../../core/widgets/phone_number/data/sources/local_country.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/country_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.addressID,
    required super.phoneNumber,
    required super.recipientName,
    required super.address1,
    required super.address2,
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
        address1: entity.address1,
        address2: entity.address2,
        category: entity.category,
        postalCode: entity.postalCode,
        city: entity.city,
        state: entity.state,
        country: entity.country,
        isDefault: entity.isDefault,
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final LocalCountry localCountry = LocalCountry();
    final dynamic isDefaultRaw = json['is_default'];
    final bool isDefault = isDefaultRaw is bool
        ? isDefaultRaw
        : <String>['true', '1', 'yes']
            .contains(isDefaultRaw?.toString().toLowerCase());
    return AddressModel(
      addressID: json['address_id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      recipientName: json['recipient_name']?.toString() ?? '',
      address1: json['address_1']?.toString() ?? '',
      address2: json['address_2']?.toString() ?? '',
      category: json['address_category']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: localCountry.getStateByName(json['country']?.toString() ?? '',
              json['state']?.toString() ?? '') ??
          StateEntity.empty(),
      country: localCountry.country(json['country']?.toString() ?? '') ??
          CountryEntity.empty(),
      isDefault: isDefault,
    );
  }

  Map<String, dynamic> _addressToJson() => <String, dynamic>{
        'recipient_name': recipientName,
        'address_1': address1,
        'address_2': address2,
        'city': city,
        'state': state?.stateName ?? '',
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
