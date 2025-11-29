import '../../../../../../core/helper_functions/country_helper.dart';

class BillingDetailsEntity {
  const BillingDetailsEntity({
    required this.subtotal,
    required this.deliveryTotal,
    required this.grandTotal,
    required this.currency,
  });

  final String subtotal;
  final String deliveryTotal;
  final String grandTotal;
  final String currency;

  String get deliveryPriceString {
    return '${CountryHelper.currencySymbolHelper(currency)} $deliveryTotal';
  }

  String get subTotalPriceString {
    return '${CountryHelper.currencySymbolHelper(currency)} $deliveryTotal';
  }

  String get totalPriceString {
    return '${CountryHelper.currencySymbolHelper(currency)} $deliveryTotal';
  }
}
