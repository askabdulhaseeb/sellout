String currencySymbolHelper(String? currency) {
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
