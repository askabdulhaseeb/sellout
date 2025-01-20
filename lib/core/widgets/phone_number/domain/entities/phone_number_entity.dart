class PhoneNumberEntity {
  PhoneNumberEntity({
    required this.countryCode,
    required this.number,
  });

  final String countryCode;
  final String number;

  String get fullNumber => '$countryCode$number';
}
