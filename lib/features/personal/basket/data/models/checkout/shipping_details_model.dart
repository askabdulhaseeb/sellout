import '../../../domain/entities/checkout/shipping_details_entity.dart';

class ShippingDetailsModel extends ShippingDetailsEntity {
  const ShippingDetailsModel({
    super.provider,
    super.parcel,
    super.serviceToken,
    super.serviceName,
    super.rateObjectId,
    super.shipmentId,
    super.coreAmount,
    super.nativeBufferAmount,
    super.nativeCurrency,
    required super.convertedBufferAmount,
    required super.convertedCurrency,
    required super.exchangeRate,
  });

  factory ShippingDetailsModel.fromJson(Map<String, dynamic> json) =>
      ShippingDetailsModel(
        provider: json['provider'],
        parcel: json['parcel'],
        serviceToken: json['service_token'],
        serviceName: json['service_name'],
        rateObjectId: json['rate_object_id'],
        shipmentId: json['shipment_id'],
        coreAmount: json['core_amount'],
        nativeBufferAmount: json['native_buffer_amount'],
        nativeCurrency: json['native_currency'],
        convertedBufferAmount: double.tryParse(
                json['converted_buffer_amount']?.toString() ?? '0') ??
            0.0,
        convertedCurrency: json['converted_currency'] ?? '',
        exchangeRate:
            double.tryParse(json['exchange_rate']?.toString() ?? '1') ?? 1.0,
      );
}
