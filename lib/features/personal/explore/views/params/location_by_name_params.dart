class FetchLocationParams {
  FetchLocationParams({required this.input, required this.apiKey});
  final String input;
  final String apiKey;

  Map<String, dynamic> toQueryParams() {
    return <String, dynamic>{
      'input': input,
      'key': apiKey,
    };
  }
}
