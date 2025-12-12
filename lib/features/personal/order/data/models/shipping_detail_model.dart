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
    super.shippingLabelUrl,
  });

  factory ShippingDetailModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? addresses =
        json['addresses'] as Map<String, dynamic>?;

    // --------- FIXED: extract label URL from postage[0].url ----------
    String? labelUrl;
    final List<dynamic>? postageList = json['postage'] as List<dynamic>?;
    if (postageList != null && postageList.isNotEmpty) {
      final firstPostage = postageList.first;
      if (firstPostage is Map<String, dynamic>) {
        labelUrl = firstPostage['url'] as String?;
      }
    }
    // ---------------------------------------------------------------

    return ShippingDetailModel(
      postage:
          postageList?.map((e) => PostageModel.fromJson(e)).toList() ??
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

      // Correct source
      shippingLabelUrl: labelUrl,
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
      shippingLabelUrl: e.shippingLabelUrl,
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

      // Optional — your backend probably ignores it
      if (shippingLabelUrl != null)
        'shipping_label': <String, String?>{'url': shippingLabelUrl},
    };
  }
}
