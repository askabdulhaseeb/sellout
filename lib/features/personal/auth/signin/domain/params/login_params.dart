import 'device_details.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  Future<Map<String, dynamic>> toMap() async {
    final Map<String, dynamic> device =
        await DeviceInfoUtil.getLoginDeviceInfo();
    return <String, dynamic>{
      'email': email.trim(),
      'password': password.trim(),
      'login_info': device,
    };
  }
}
