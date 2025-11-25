import '../../../domain/entities/checkout/shipping_details_entity.dart';

class ShippingDetailsModel extends ShippingDetailsEntity {
  const ShippingDetailsModel({
    required super.convertedBufferAmount,
    required super.convertedCurrency,
    required super.exchangeRate,
    super.provider,
    super.parcel,
    super.serviceToken,
    super.serviceName,
    super.rateObjectId,
    super.shipmentId,
    super.coreAmount,
    super.nativeBufferAmount,
    super.nativeCurrency,
  });

  factory ShippingDetailsModel.fromJson(Map<String, dynamic> json) =>
      ShippingDetailsModel(
        provider: json['provider']?.toString() ?? '',
        parcel: json['parcel']?.toString() ?? '',
        serviceToken: json['service_token']?.toString() ?? '',
        serviceName: json['service_name']?.toString() ?? '',
        rateObjectId: json['rate_object_id']?.toString() ?? '',
        shipmentId: json['shipment_id']?.toString() ?? '',
        coreAmount: json['core_amount']?.toString() ?? '',
        nativeBufferAmount: json['native_buffer_amount']?.toString() ?? '',
        nativeCurrency: json['native_currency']?.toString() ?? '',
        convertedBufferAmount: double.tryParse(
                json['converted_buffer_amount']?.toString() ?? '0') ??
            0.0,
        convertedCurrency: json['converted_currency'] ?? '',
        exchangeRate:
            double.tryParse(json['exchange_rate']?.toString() ?? '1') ?? 1.0,
      );
}
