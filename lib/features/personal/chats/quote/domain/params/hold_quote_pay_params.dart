class HoldQuotePayParams {
  HoldQuotePayParams({
    required this.currency,
    required this.quoteId,
  });
  final String currency;
  final String quoteId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'quote_id': quoteId,
    };
  }

  @override
  String toString() =>
      'HoldQuotePayParams(currency: $currency, trackId: $quoteId)';
}
