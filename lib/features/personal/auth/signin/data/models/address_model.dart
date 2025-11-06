import 'dart:convert';
import 'package:hive/hive.dart';
import '../../domain/entities/address_entity.dart';
import '../../../../../../core/widgets/phone_number/data/sources/local_country.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/country_entity.dart';
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
    // Attempt to resolve a real CountryEntity from the local Hive box if available.
    CountryEntity countryEntity;
    final String countryName = (json['country'] ?? '').toString();
    if (countryName.isNotEmpty && Hive.isBoxOpen(LocalCountry.boxTitle)) {
      final Box<CountryEntity> box =
          Hive.box<CountryEntity>(LocalCountry.boxTitle);
      CountryEntity? found;
      for (final CountryEntity c in box.values) {
        if (c.displayName == countryName ||
            c.shortName == countryName ||
            c.countryName == countryName ||
            c.countryCode == countryName) {
          found = c;
          break;
        }
      }
      countryEntity = found ??
          CountryEntity(
            flag: '',
            shortName: countryName,
            displayName: countryName,
            countryName: countryName,
            countryCode: countryName,
            countryCodes: <String>[],
            language: '',
            iosCode: '',
            isoCode: '',
            alpha2: '',
            alpha3: '',
            numberFormat: NumberFormatEntity(format: '', regex: ''),
            currency: <String>[],
            isActive: false,
            states: <StateEntity>[],
          );
    } else {
      countryEntity = CountryEntity(
        flag: '',
        shortName: countryName,
        displayName: countryName,
        countryName: countryName,
        countryCode: countryName,
        countryCodes: <String>[],
        language: '',
        iosCode: '',
        isoCode: '',
        alpha2: '',
        alpha3: '',
        numberFormat: NumberFormatEntity(format: '', regex: ''),
        currency: <String>[],
        isActive: false,
        states: <StateEntity>[],
      );
    }

    // Resolve StateEntity from the country's states list if possible.
    final String stateName = (json['state'] ?? '').toString();
    StateEntity stateEntity =
        StateEntity(stateName: stateName, stateCode: '', cities: <String>[]);
    if (countryEntity.states.isNotEmpty) {
      final StateEntity foundState = countryEntity.states.firstWhere(
        (s) => s.stateName == stateName || s.stateCode == stateName,
        orElse: () => StateEntity(
            stateName: stateName, stateCode: '', cities: <String>[]),
      );
      stateEntity = foundState;
    }

    return AddressModel(
      addressID: json['address_id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      recipientName: json['recipient_name']?.toString() ?? '',
      address: json['address_1']?.toString() ?? '',
      category: json['address_category']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: stateEntity,
      country: countryEntity,
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
