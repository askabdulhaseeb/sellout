import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';

class SignupBasicInfoParams {
  SignupBasicInfoParams({
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    this.privacy = PrivacyType.public,
  });

  final String name;
  final String username;
  final String email;
  final PhoneNumberEntity phone;
  final String password;
  final PrivacyType privacy;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'display_name': name.trim(),
      'user_name': username.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'country_code': phone.countryCode.trim(),
      'phone_number': phone.number.trim(),
      'profile_type': privacy.json.trim(),
    };
  }
}
