import '../../domain/entities/address_entity.dart';
export '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.city,
    required super.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        city: json['city'],
        country: json['country'],
      );
}
