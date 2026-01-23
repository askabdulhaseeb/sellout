/// Available search radius options for service points
enum SearchRadius {
  meters500('500m', 500),
  km1('1 km', 1000),
  km2('2 km', 2000),
  km5('5 km', 5000);

  const SearchRadius(this.label, this.meters);

  /// Display label for the radius
  final String label;

  /// Radius value in meters
  final int meters;
}

/// Category filters for service point types
enum ServicePointCategory {
  all('all'),
  shops('shops'),
  lockers('lockers'),
  post('post');

  const ServicePointCategory(this.key);

  /// Translation key for the category
  final String key;
}
