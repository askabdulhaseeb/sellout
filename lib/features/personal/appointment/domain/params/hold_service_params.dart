class HoldServiceParams {
  HoldServiceParams({
    required this.currency,
    required this.trackId,
  });

  factory HoldServiceParams.fromMap(Map<String, dynamic> map) {
    return HoldServiceParams(
      currency: map['currency'] ?? '',
      trackId: map['track_id'] ?? '',
    );
  }
  final String currency;
  final String trackId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'track_id': trackId,
    };
  }
}
