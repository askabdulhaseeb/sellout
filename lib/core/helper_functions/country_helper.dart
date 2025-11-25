class CountryHelper {
  static String currencySymbolHelper(String? currency) {
    switch (currency?.toUpperCase()) {
      case 'PKR':
        return '₨';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      default:
        return 'na';
    }
  }

  /// Returns the exchange rate from one currency to another.
  static double getExchangeRate(String from, String to) {
    if (from.toUpperCase() == to.toUpperCase()) return 1.0;

    // Approximate exchange rates (should be updated with real-time rates)
    const Map<String, Map<String, double>> rates =
        <String, Map<String, double>>{
      'USD': <String, double>{'GBP': 0.79, 'PKR': 278.0},
      'GBP': <String, double>{'USD': 1.27, 'PKR': 352.0},
      'PKR': <String, double>{'USD': 0.0036, 'GBP': 0.0028},
    };

    return rates[from.toUpperCase()]?[to.toUpperCase()] ?? 1.0;
  }

  /// Returns a valid ISO Alpha-2 country code from various inputs.
  static String? getCountryAlpha2(String countryInput) {
    if (countryInput.isEmpty) return null;

    final String upper = countryInput.trim().toUpperCase();

    // If already Alpha-2 (2 letters), return as is
    if (upper.length == 2) return upper;

    // Alpha-3 codes to Alpha-2
    const Map<String, String> alpha3ToAlpha2 = <String, String>{
      'PAK': 'PK',
      'USA': 'US',
      'GBR': 'GB',
      'IND': 'IN',
      'CAN': 'CA',
      // Add more as needed
    };

    // Full country names to Alpha-2
    const Map<String, String> fullNameToAlpha2 = <String, String>{
      'PAKISTAN': 'PK',
      'UNITED STATES': 'US',
      'UNITED KINGDOM': 'GB',
      'INDIA': 'IN',
      'CANADA': 'CA',
      // Add more as needed
    };

    return alpha3ToAlpha2[upper] ?? fullNameToAlpha2[upper];
  }

  /// Returns a formatted price string with currency symbol.
  static String formatPrice(double price, String currency) {
    return '${currencySymbolHelper(currency)}${price.toStringAsFixed(2)}';
  }
}
