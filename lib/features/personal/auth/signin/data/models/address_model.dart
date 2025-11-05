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
    required this.state,
  });

  final String state;

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
        state: '', // Default empty state
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addressID: json['address_id'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        recipientName: json['recipient_name'] ?? '',
        address: json['address_1'] ?? '',
        category: json['address_category'] ?? '',
        postalCode: json['postal_code'] ?? '',
        townCity: json['city'] ?? '', // Map 'city' to townCity
        country: json['country'] ?? 'UK',
        isDefault: json['is_default'] ?? false,
        state: json['state'] ?? '',
      );

  Map<String, dynamic> _addressToJson() => <String, dynamic>{
        'recipient_name': recipientName,
        'address_1': address,
        'city': townCity, // Using townCity for city field
        'state': state,
        'phone_number': phoneNumber,
        'postal_code': postalCode,
        'address_category': category,
        'country': country,
        'is_default': isDefault,
      };

  Map<String, dynamic> toJson() => _addressToJson();
  Map<String, dynamic> toShippingJson() => _addressToJson();
  
  String toOfferJson() => json.encode(_addressToJson());
  
  String toCheckoutJson() => json.encode({
        'buyer_address': _addressToJson(),
      });
}