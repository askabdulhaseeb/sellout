class CountryCodeHelper {
  static final Map<String, String> _countryCodeMap = {
    'PAKISTAN': 'PK',
    'PAK': 'PK',
    'UNITED STATES': 'US',
    'USA': 'US',
    'UNITED KINGDOM': 'GB',
    'UK': 'GB',
  };

  /// Returns ISO Alpha-2 country code (like 'PK') from input (like 'PAK', 'Pakistan')
  static String? getCountryCode(String countryInput) {
    final upper = countryInput.trim().toUpperCase();
    return _countryCodeMap[upper];
  }
}
