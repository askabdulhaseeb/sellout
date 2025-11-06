class AddressParams {
  AddressParams({
    required this.recipientName,
    required this.address1,
    required this.city,
    required this.state,
    required this.phoneNumber,
    required this.postalCode,
    required this.addressCategory,
    required this.country,
    required this.isDefault,
    required this.addressId,
     this.address2,
    this.action = '',
  });
  final String recipientName;
  final String address1;
  final String? address2;
  final String city;
  final String state;
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
     if(address2 != '') 'address_2': address2,
      'city': city,
      'state': state,
      'phone_number': phoneNumber,
      'postal_code': postalCode,
      'address_category': addressCategory,
      'country': country.toLowerCase(),
      'is_default': isDefault,
    };
  }
}
