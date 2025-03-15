class VerifyPinParams {
  VerifyPinParams({required this.uid, this.otp});

  final String uid;
  final String? otp;

  Map<String, dynamic> tomap() {
    return <String, dynamic>{'otp': otp?.trim()};
  }
}
