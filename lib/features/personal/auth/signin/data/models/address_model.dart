import 'dart:convert';
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
    super.isDefault = false,
  });

  factory AddressModel.fromEntity(AddressEntity entity) => AddressModel(
        addressID: entity.addressID,
        phoneNumber: entity.phoneNumber,
        recipientName: entity.recipientName,
        address: entity.address,
        category: entity.category,
        postalCode: entity.postalCode,
        townCity: entity.townCity,
        country: entity.country,
        isDefault: entity.isDefault,
      );

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
  String toOfferJson() => json.encode(<String, dynamic>{
        'recipient_name': super.recipientName,
        'address_1': super.address,
        'town_city': super.townCity,
        'phone_number': super.phoneNumber,
        'postal_code': super.postalCode,
        'address_category': super.category,
        'country': super.country,
        'is_default': super.isDefault,
      });
  String checkoutAddressToJson() => json.encode(<String, Map<String, Object>>{
        'buyer_address': <String, Object>{
          'recipient_name': recipientName,
          'address_1': address,
          'town_city': townCity,
          'phone_number': phoneNumber,
          'postal_code': postalCode,
          'address_category': category,
          'country': country,
          'is_default': super.isDefault,
        },
      });
  Map<String, dynamic> shippingAddressToJson() => <String, dynamic>{
        'recipient_name': super.recipientName,
        'address_1': super.address,
        'town_city': super.townCity,
        'phone_number': super.phoneNumber,
        'postal_code': super.postalCode,
        'address_category': super.category,
        'country': super.country,
        'is_default': super.isDefault,
      };
}
