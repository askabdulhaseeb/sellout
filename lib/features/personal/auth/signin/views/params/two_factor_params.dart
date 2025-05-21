class TwoFactorParams {
  factory TwoFactorParams.fromJson(Map<String, dynamic> json) {
    return TwoFactorParams(
      code: json['code'] ?? '',
      sessionKey: json['session_key'] ?? '',
    );
  }

  TwoFactorParams({
    required this.code,
    required this.sessionKey,
  });
  final String code;
  final String sessionKey;

  Map<String, dynamic> toJson() {
    return {
      'code': code.trim(),
      'session_key': sessionKey.trim(),
    };
  }
}
