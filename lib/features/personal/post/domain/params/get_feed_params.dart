class GetFeedParams {
  GetFeedParams({
    required this.type,
    required this.key,
  });
  final String type;
  final String key;

  Map<String, String> toQueryParameters() {
    return <String, String>{
      'type': type,
      'key': key,
    };
  }
}
