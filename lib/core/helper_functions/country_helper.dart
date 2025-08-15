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

  static String? getCountryCode(String countryInput) {
    final Map<String, String> _countryCodeMap = <String, String>{
      'PAKISTAN': 'PK',
      'PAK': 'PK',
      'UNITED STATES': 'US',
      'USA': 'US',
      'UNITED KINGDOM': 'GB',
      'UK': 'GB',
    };
    final String upper = countryInput.trim().toUpperCase();
    return _countryCodeMap[upper];
  }
}
