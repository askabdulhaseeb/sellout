enum ServiceSortOption {
  bestMatch(code: 'best_match', json: 'best_match'),
  nearby(code: 'nearby', json: 'nearby'),
  rating(code: 'top_rated', json: 'rating'),
  priceAscending(code: 'lowest_price', json: 'low_to_high'),
  priceDescending(code: 'highest_price', json: 'high_to_low');

  const ServiceSortOption({required this.code, required this.json});

  final String code;
  final String json;
}
