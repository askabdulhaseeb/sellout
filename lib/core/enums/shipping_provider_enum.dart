enum ShippingProvider {
  dhl,
  ups,
  fedex,
  gls,
  dpd,
  postnl,
  usps,
  sendcloud,
  shippo,
  hermes,
  inpost,
  royalmail,
  evri,
  other,
}

const Map<ShippingProvider, List<String>> providerKeywords =
    <ShippingProvider, List<String>>{
      ShippingProvider.dhl: <String>['dhl'],

      ShippingProvider.ups: <String>['ups'],
      ShippingProvider.fedex: <String>['fedex'],
      ShippingProvider.gls: <String>['gls'],
      ShippingProvider.dpd: <String>['dpd'],
      ShippingProvider.postnl: <String>['postnl'],
      ShippingProvider.usps: <String>['usps'],
      ShippingProvider.sendcloud: <String>['sendcloud'],
      ShippingProvider.shippo: <String>['shippo'],
      ShippingProvider.hermes: <String>['hermes'],
      ShippingProvider.inpost: <String>['inpost'],
      ShippingProvider.royalmail: <String>['royal_mail', 'royalmail'],
      ShippingProvider.evri: <String>['evri'],
      ShippingProvider.other: <String>[],
    };

const Map<ShippingProvider, String> providerDisplayNames =
    <ShippingProvider, String>{
      ShippingProvider.dhl: 'DHL',
      ShippingProvider.ups: 'UPS',
      ShippingProvider.fedex: 'FedEx',
      ShippingProvider.gls: 'GLS',
      ShippingProvider.dpd: 'DPD',
      ShippingProvider.postnl: 'PostNL',
      ShippingProvider.usps: 'USPS',
      ShippingProvider.sendcloud: 'Sendcloud',
      ShippingProvider.shippo: 'Shippo',
      ShippingProvider.hermes: 'Hermes',
      ShippingProvider.inpost: 'InPost',
      ShippingProvider.royalmail: 'Royal Mail',
      ShippingProvider.evri: 'Evri',
      ShippingProvider.other: 'Other',
    };

ShippingProvider getProviderEnum(String providerName) {
  final String lower = providerName.toLowerCase();
  for (final MapEntry<ShippingProvider, List<String>> entry
      in providerKeywords.entries) {
    for (final String keyword in entry.value) {
      if (lower.contains(keyword)) {
        return entry.key;
      }
    }
  }
  return ShippingProvider.other;
}
