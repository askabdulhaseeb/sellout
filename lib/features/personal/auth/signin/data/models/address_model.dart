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
        : <String>[
            'true',
            '1',
            'yes',
          ].contains(isDefaultRaw?.toString().toLowerCase());

    final String rawStateName = json['state']?.toString() ?? '';
    final String rawCountryName = json['country']?.toString() ?? '';

    return AddressModel(
      addressID: json['address_id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      recipientName: json['recipient_name']?.toString() ?? '',
      address1: json['address_1']?.toString() ?? '',
      address2: json['address_2']?.toString() ?? '',
      category: json['address_category']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: _parseState(localCountry, rawCountryName, rawStateName),
      country: localCountry.country(rawCountryName) ?? CountryEntity.empty(),
      isDefault: isDefault,
    );
  }

  /// Parses the state from JSON, preserving the raw value if lookup fails.
  static StateEntity _parseState(
    LocalCountry localCountry,
    String countryName,
    String stateName,
  ) {
    // If state name is empty, return empty entity
    if (stateName.trim().isEmpty) {
      return StateEntity.empty();
    }

    // Try to find a matching state in our local data
    final StateEntity? matchedState = localCountry.getStateByName(
      countryName,
      stateName,
    );

    // If found, use the matched state; otherwise preserve the raw name
    return matchedState ?? StateEntity.fromRawName(stateName);
  }

  Map<String, dynamic> _addressToJson() => <String, dynamic>{
    'recipient_name': recipientName,
    'address_1': address1,
    'address_2': address2,
    'city': city,
    'state': _sanitizeForApi(state.stateName),
    'phone_number': phoneNumber,
    'postal_code': postalCode,
    'address_category': category,
    'country': _sanitizeForApi(country.displayName),
    'is_default': isDefault,
  };

  /// Sanitizes a value for API - returns empty string for invalid values like 'na'.
  static String _sanitizeForApi(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'na') {
      return '';
    }
    return trimmed;
  }

  Map<String, dynamic> toJson() => _addressToJson();
  Map<String, dynamic> toShippingJson() => _addressToJson();
  Map<String, dynamic> toOfferMap() => _addressToJson();

  String toOfferJson() => json.encode(_addressToJson());

  String toCheckoutJson() => json.encode(<String, Map<String, dynamic>>{
    'buyer_address': _addressToJson(),
  });
}
