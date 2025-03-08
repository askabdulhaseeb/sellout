class OtpResponseParams {
  final String? message;
  final String? value;
  final OtpResult? result;
  String? uid;

  OtpResponseParams({
    this.message,
    this.value,
    this.result,
    this.uid,
  });

  factory OtpResponseParams.fromJson(Map<String, dynamic> json) {
    return OtpResponseParams(
      message: json['message'],
      value: json['value'],
      result: OtpResult.fromJson(json['result']),
      uid: json['uid'],
    );
  }
}

class OtpResult {
  final OtpAttributes attributes;

  OtpResult({required this.attributes});

  factory OtpResult.fromJson(Map<String, dynamic> json) {
    return OtpResult(
      attributes: OtpAttributes.fromJson(json['Attributes']),
    );
  }
}

class OtpAttributes {
  final String otp;
  final int otpExpiry;

  OtpAttributes({required this.otp, required this.otpExpiry});

  factory OtpAttributes.fromJson(Map<String, dynamic> json) {
    return OtpAttributes(
      otp: json['otp'],
      otpExpiry: json['otp_expiry'],
    );
  }
}
