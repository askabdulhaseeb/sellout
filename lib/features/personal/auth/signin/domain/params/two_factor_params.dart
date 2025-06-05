class TwoFactorParams {
  TwoFactorParams({
    required this.sessionKey,
    this.code,
    this.deviceId,
  });

  final String? code;
  final String sessionKey;
  final String? deviceId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code?.trim(),
      'session_key': sessionKey.trim(),
    };
  }

  Map<String, dynamic> resendCodeMap() {
    return <String, dynamic>{
      'session_key': sessionKey.trim(),
      // 'device_id': deviceId?.trim(),
    };
  }
}
