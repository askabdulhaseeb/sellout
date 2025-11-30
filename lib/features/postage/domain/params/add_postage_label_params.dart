class BuyPostageLabelParams {
  const BuyPostageLabelParams({
    required this.objectId,
  });

  factory BuyPostageLabelParams.fromJson(Map<String, dynamic> json) {
    return BuyPostageLabelParams(
      objectId: json['object_id'] ?? '',
    );
  }
  final String objectId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'object_id': objectId,
    };
  }
}
