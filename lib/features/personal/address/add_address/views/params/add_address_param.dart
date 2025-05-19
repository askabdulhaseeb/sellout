class AddressParams {
  AddressParams({
    required this.recipientName,
    required this.address1,
    required this.townCity,
    required this.phoneNumber,
    required this.postalCode,
    required this.addressCategory,
    required this.country,
    required this.isDefault,
    required this.addressId,
    this.action = '',
  });
  final String recipientName;
  final String address1;
  final String townCity;
  final String phoneNumber;
  final String postalCode;
  final String addressCategory;
  final String country;
  final bool isDefault;
  final String addressId;
  final String action;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (addressId != '') 'address_id': addressId,
      'recipient_name': recipientName,
      'address_1': address1,
      'town_city': townCity,
      'phone_number': phoneNumber,
      'postal_code': postalCode,
      'address_category': addressCategory,
      'country': country.toLowerCase(),
      'is_default': isDefault,
    };
  }
}
