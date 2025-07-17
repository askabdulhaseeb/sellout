enum SortOption {
  dateAscending(code: 'newly_list', json: ''),
  priceAscending(code: 'lowest_price', json: 'low_to_high'),
  priceDescending(code: 'highest_price', json: 'high_to_low');

  const SortOption({required this.code, required this.json});

  final String code; // for localization key like 'newly_list'
  final String json; // for sending to API like 'price_desc'

  /// Localized text for UI
  String get displayText => code;

  /// Convert from JSON value
  static SortOption? fromJson(String? jsonValue) {
    return SortOption.values.firstWhere(
      (SortOption e) => e.json == jsonValue,
      orElse: () => SortOption.dateAscending, // default fallback
    );
  }
}
