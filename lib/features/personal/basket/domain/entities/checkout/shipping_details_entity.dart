class ShippingDetailsEntity {
  const ShippingDetailsEntity({
    required this.convertedBufferAmount,
    required this.convertedCurrency,
    required this.exchangeRate,
    this.provider,
    this.parcel,
    this.serviceToken,
    this.serviceName,
    this.rateObjectId,
    this.shipmentId,
    this.coreAmount,
    this.nativeBufferAmount,
    this.nativeCurrency,
  });

  final String? provider;
  final String? parcel;
  final String? serviceToken;
  final String? serviceName;
  final String? rateObjectId;
  final String? shipmentId;
  final String? coreAmount;
  final String? nativeBufferAmount;
  final String? nativeCurrency;
  final double convertedBufferAmount;
  final String convertedCurrency;
  final double exchangeRate;
}
