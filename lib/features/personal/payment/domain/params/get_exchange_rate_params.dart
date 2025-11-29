class GetExchangeRateParams {
  const GetExchangeRateParams({
    required this.from,
    required this.to,
  });

  final String from;
  final String to;

  Map<String, dynamic> toJson() {
    return {
      'from_currency': from,
      'to_currency': to,
    };
  }
}
