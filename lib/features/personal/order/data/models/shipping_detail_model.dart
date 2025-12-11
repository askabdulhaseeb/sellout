import '../../../auth/signin/data/models/address_model.dart';
import '../../domain/entities/shipping_detail_entity.dart';
import '../../domain/entities/postage_entity.dart';
import 'postage_model.dart';
import 'fast_delivery_model.dart';

class ShippingDetailModel extends ShippingDetailEntity {
  ShippingDetailModel({
    required super.postage,
    super.fastDelivery,
    super.fromAddress,
    super.toAddress,
  });
  factory ShippingDetailModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? addresses =
        json['addresses'] as Map<String, dynamic>?;
    return ShippingDetailModel(
      postage:
          (json['postage'] as List<dynamic>?)
              ?.map((e) => PostageModel.fromJson(e))
              .toList() ??
          <PostageModel>[],
      fastDelivery: json['fast_delivery'] != null
          ? FastDeliveryModel.fromJson(json['fast_delivery'])
          : null,
      fromAddress: addresses != null && addresses['from_address'] != null
          ? AddressModel.fromJson(addresses['from_address'])
          : null,
      toAddress: addresses != null && addresses['to_address'] != null
          ? AddressModel.fromJson(addresses['to_address'])
          : null,
    );
  }

  factory ShippingDetailModel.fromEntity(ShippingDetailEntity e) {
    return ShippingDetailModel(
      postage: e.postage
          .map((PostageEntity p) => PostageModel.fromEntity(p))
          .toList(),
      fastDelivery: e.fastDelivery != null
          ? FastDeliveryModel.fromEntity(e.fastDelivery!)
          : null,
      fromAddress: e.fromAddress != null
          ? AddressModel.fromEntity(e.fromAddress!)
          : null,
      toAddress: e.toAddress != null
          ? AddressModel.fromEntity(e.toAddress!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'postage': postage
          .map((PostageEntity e) => (e as PostageModel).toJson())
          .toList(),
      'fast_delivery': fastDelivery != null
          ? (fastDelivery as FastDeliveryModel).toJson()
          : null,
      'addresses': <String, dynamic>{
        if (fromAddress != null)
          'from_address': (fromAddress as AddressModel).toShippingJson(),
        if (toAddress != null)
          'to_address': (toAddress as AddressModel).toShippingJson(),
      },
    };
  }
}
