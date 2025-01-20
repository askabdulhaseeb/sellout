class SignupOptParams {
  SignupOptParams({required this.uid, this.otp});

  final String uid;
  final String? otp;

  Map<String, dynamic> toVarifyMap() {
    return <String, dynamic>{'otp': otp?.trim()};
  }
}
