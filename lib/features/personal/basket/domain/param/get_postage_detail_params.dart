import 'dart:convert';
import '../../../auth/signin/data/models/address_model.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';

class ItemDeliveryPreference {
  const ItemDeliveryPreference({
    required this.cartItemId,
    required this.deliveryMode,
    this.servicePointId,
  });

  final String cartItemId;
  final String deliveryMode;
  final String? servicePointId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'cart_item_id': cartItemId,
    'delivery_mode': deliveryMode,
    if (servicePointId != null) 'service_point_id': servicePointId,
  };
}

class GetPostageDetailParam {
  const GetPostageDetailParam({
    required this.buyerAddress,
    this.itemsDeliveryPreferences = const <ItemDeliveryPreference>[],
    this.fastDelivery = const <String>[],
  });

  final AddressEntity buyerAddress;
  final List<ItemDeliveryPreference> itemsDeliveryPreferences;
  final List<String> fastDelivery;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'buyer_address': AddressModel.fromEntity(buyerAddress).toShippingJson(),
    'items_delivery_preferences': itemsDeliveryPreferences
        .map((ItemDeliveryPreference item) => item.toJson())
        .toList(),
    if (fastDelivery.isNotEmpty) 'fast_delivery': fastDelivery,
  };

  String toJson() => json.encode(toMap());
}
