import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../auth/signin/data/models/address_model.dart';
import '../../../domain/entities/cart/added_shipping_response_entity.dart';

class AddShippingResponseModel extends AddedShippingResponseEntity {
  AddShippingResponseModel({
    required super.message,
    required super.cart,
  });

  factory AddShippingResponseModel.fromJson(Map<String, dynamic> json) {
    return AddShippingResponseModel(
      message: json['message'] ?? '',
      cart: AddShippingCartModel.fromJson(json['cart'] ?? <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
      'cart': (cart as AddShippingCartModel).toJson(),
    };
  }
}

class AddShippingCartModel extends AddedShippingCartEntity {
  AddShippingCartModel({
    required super.updatedAt,
    required super.cartItems,
  });

  factory AddShippingCartModel.fromJson(Map<String, dynamic> json) {
    return AddShippingCartModel(
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      cartItems: (json['cart_items'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => AddShippingCartItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'updated_at': updatedAt.toIso8601String(),
      'cart_items': cartItems
          .map((AddShippingCartItemEntity e) =>
              (e as AddShippingCartItemModel).toJson())
          .toList(),
    };
  }
}

class AddShippingCartItemModel extends AddShippingCartItemEntity {
  AddShippingCartItemModel({
    required super.quantity,
    required super.cartItemId,
    required super.selectedShipping,
    super.postId,
    super.listId,
    super.color,
    super.size,
    super.status,
  });

  factory AddShippingCartItemModel.fromJson(Map<String, dynamic> json) {
    return AddShippingCartItemModel(
      quantity: json['quantity'] ?? 0,
      cartItemId: json['cart_item_id'] ?? '',
      postId: json['post_id'],
      listId: json['list_id'],
      color: json['color'],
      size: json['size'],
      status: CartItemStatusType.fromJson(json['status']),
      selectedShipping:
          (json['selected_shipping'] as List<dynamic>? ?? <dynamic>[])
              .map((e) => SelectedShippingModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'quantity': quantity,
      'cart_item_id': cartItemId,
      'post_id': postId,
      'list_id': listId,
      'color': color,
      'size': size,
      'status': status,
      'selected_shipping': selectedShipping
          .map((SelectedShippingEntity e) =>
              (e as SelectedShippingModel).toJson())
          .toList(),
    };
  }
}

class SelectedShippingModel extends SelectedShippingEntity {
  SelectedShippingModel({
    required super.parcel,
    required super.serviceName,
    required super.rateObjectId,
    required super.parcelIndex,
    required super.convertedCurrency,
    required super.nativeBufferAmount,
    required super.toAddress,
    required super.parcelId,
    required super.shipmentId,
    required super.provider,
    required super.convertedBufferAmount,
    required super.fastDelivery,
    required super.deliveryType,
    required super.nativeCurrency,
    required super.coreAmount,
    required super.fromAddress,
    required super.serviceToken,
  });

  factory SelectedShippingModel.fromJson(Map<String, dynamic> json) {
    return SelectedShippingModel(
      parcel: ParcelModel.fromJson(json['parcel'] ?? <String, dynamic>{}),
      serviceName: json['service_name'] ?? '',
      rateObjectId: json['rate_object_id'] ?? '',
      parcelIndex: json['parcel_index'] ?? 0,
      convertedCurrency: json['converted_currency'] ?? '',
      nativeBufferAmount: (json['native_buffer_amount'] ?? 0.0).toDouble(),
      toAddress:
          AddressModel.fromJson(json['to_address'] ?? <String, dynamic>{}),
      parcelId: json['parcel_id'] ?? '',
      shipmentId: json['shipment_id'] ?? '',
      provider: json['provider'] ?? '',
      convertedBufferAmount:
          (json['converted_buffer_amount'] ?? 0.0).toDouble(),
      fastDelivery: FastDeliveryModel.fromJson(
          json['fast_delivery'] ?? <String, dynamic>{}),
      deliveryType: json['delivery_type'] ?? '',
      nativeCurrency: json['native_currency'] ?? '',
      coreAmount: (json['core_amount'] ?? 0.0).toDouble(),
      fromAddress:
          AddressModel.fromJson(json['from_address'] ?? <String, dynamic>{}),
      serviceToken: json['service_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'parcel': (parcel as ParcelModel).toJson(),
      'service_name': serviceName,
      'rate_object_id': rateObjectId,
      'parcel_index': parcelIndex,
      'converted_currency': convertedCurrency,
      'native_buffer_amount': nativeBufferAmount,
      'to_address': (toAddress as AddressModel).toJson(),
      'parcel_id': parcelId,
      'shipment_id': shipmentId,
      'provider': provider,
      'converted_buffer_amount': convertedBufferAmount,
      'fast_delivery': (fastDelivery as FastDeliveryModel).toJson(),
      'delivery_type': deliveryType,
      'native_currency': nativeCurrency,
      'core_amount': coreAmount,
      'from_address': (fromAddress as AddressModel).toJson(),
      'service_token': serviceToken,
    };
  }
}

class ParcelModel extends ParcelEntity {
  ParcelModel({
    required super.length,
    required super.width,
    required super.distanceUnit,
    required super.weight,
    required super.massUnit,
    required super.height,
  });

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    return ParcelModel(
      length: json['length'] ?? '',
      width: json['width'] ?? '',
      distanceUnit: json['distanceUnit'] ?? '',
      weight: json['weight'] ?? '',
      massUnit: json['massUnit'] ?? '',
      height: json['height'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'length': length,
      'width': width,
      'distanceUnit': distanceUnit,
      'weight': weight,
      'massUnit': massUnit,
      'height': height,
    };
  }
}

class FastDeliveryModel extends FastDeliveryEntity {
  FastDeliveryModel({
    required super.available,
    required super.requested, super.message,
  });

  factory FastDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FastDeliveryModel(
      available: json['available'] ?? false,
      message: json['message'],
      requested: json['requested'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'available': available,
      'message': message,
      'requested': requested,
    };
  }
}
