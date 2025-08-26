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
        return '';
    }
  }

  /// Returns a valid ISO Alpha-2 country code from various inputs.
  static String? getCountryAlpha2(String countryInput) {
    if (countryInput.isEmpty) return null;

    final String upper = countryInput.trim().toUpperCase();

    // If already Alpha-2 (2 letters), return as is
    if (upper.length == 2) return upper;

    // Alpha-3 codes to Alpha-2
    const Map<String, String> alpha3ToAlpha2 = {
      'PAK': 'PK',
      'USA': 'US',
      'GBR': 'GB',
      'IND': 'IN',
      'CAN': 'CA',
      // Add more as needed
    };

    // Full country names to Alpha-2
    const Map<String, String> fullNameToAlpha2 = {
      'PAKISTAN': 'PK',
      'UNITED STATES': 'US',
      'UNITED KINGDOM': 'GB',
      'INDIA': 'IN',
      'CANADA': 'CA',
      // Add more as needed
    };

    return alpha3ToAlpha2[upper] ?? fullNameToAlpha2[upper];
  }
}
