class SignupUpdateUserInfoParams {
  SignupUpdateUserInfoParams({
    required this.uid,
    required this.name,
    required this.dob,
  });

  final String uid;
  final String? name;
  final DateTime? dob;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }
}
