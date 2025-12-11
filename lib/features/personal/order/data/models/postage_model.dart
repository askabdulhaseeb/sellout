import '../../domain/entities/postage_entity.dart';

class PostageModel extends PostageEntity {
  PostageModel({
    super.parcel,
    super.provider,
    super.convertedBufferAmount,
    super.serviceName,
    super.rateObjectId,
    super.nativeCurrency,
    super.convertedCurrency,
    super.nativeBufferAmount,
    super.coreAmount,
    super.shipmentId,
    super.serviceToken,
  });

  factory PostageModel.fromJson(Map<String, dynamic> json) {
    return PostageModel(
      parcel: json['parcel'],
      provider: json['provider'],
      convertedBufferAmount: json['converted_buffer_amount'],
      serviceName: json['service_name'],
      rateObjectId: json['rate_object_id'],
      nativeCurrency: json['native_currency'],
      convertedCurrency: json['converted_currency'],
      nativeBufferAmount: json['native_buffer_amount'],
      coreAmount: json['core_amount'],
      shipmentId: json['shipment_id'],
      serviceToken: json['service_token'],
    );
  }

  factory PostageModel.fromEntity(PostageEntity e) {
    return PostageModel(
      parcel: e.parcel,
      provider: e.provider,
      convertedBufferAmount: e.convertedBufferAmount,
      serviceName: e.serviceName,
      rateObjectId: e.rateObjectId,
      nativeCurrency: e.nativeCurrency,
      convertedCurrency: e.convertedCurrency,
      nativeBufferAmount: e.nativeBufferAmount,
      coreAmount: e.coreAmount,
      shipmentId: e.shipmentId,
      serviceToken: e.serviceToken,
    );
  }
  // All fields inherited from PostageEntity

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'parcel': parcel,
      'provider': provider,
      'converted_buffer_amount': convertedBufferAmount,
      'service_name': serviceName,
      'rate_object_id': rateObjectId,
      'native_currency': nativeCurrency,
      'converted_currency': convertedCurrency,
      'native_buffer_amount': nativeBufferAmount,
      'core_amount': coreAmount,
      'shipment_id': shipmentId,
      'service_token': serviceToken,
    };
  }
}
