import '../../domain/entity/business_address_entity.dart';

class BusinessAddressModel extends BusinessAddressEntity {
  BusinessAddressModel({
    required super.secondaryAddress,
    required super.postalCode,
    required super.firstAddress,
    required super.city,
  });

  factory BusinessAddressModel.fromJson(Map<String, dynamic> json) =>
      BusinessAddressModel(
        secondaryAddress: json['secondary_address'] ?? '',
        postalCode: json['postal_code'] != null
            ? int.tryParse(json['postal_code'].toString()) ?? 0
            : 0,
        firstAddress: json['first_address'] ?? '',
        city: json['city'] ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'secondary_address': secondaryAddress,
        'postal_code': postalCode,
        'first_address': firstAddress,
        'city': city,
      };
}
