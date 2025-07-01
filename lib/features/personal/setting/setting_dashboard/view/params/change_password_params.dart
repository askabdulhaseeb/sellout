import '../../../../auth/signin/data/sources/local/local_auth.dart';

class ChangePasswordParams {
  const ChangePasswordParams({
    required this.password,
    required this.oldPassword,
  });

  final String password;
  final String oldPassword;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': LocalAuth.uid,
      'password': password.trim(),
      'old_password': oldPassword.trim(),
    };
  }
}
