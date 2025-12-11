import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../order/domain/entities/fast_delivery_entity.dart';

class AddedShippingResponseEntity {
  AddedShippingResponseEntity({
    required this.message,
    required this.cart,
  });
  final String message;
  final AddedShippingCartEntity cart;
}

class AddedShippingCartEntity {
  AddedShippingCartEntity({
    required this.updatedAt,
    required this.cartItems,
  });
  final DateTime updatedAt;
  final List<AddShippingCartItemEntity> cartItems;
}

class AddShippingCartItemEntity {
  AddShippingCartItemEntity({
    required this.quantity,
    required this.cartItemId,
    required this.selectedShipping,
    this.postId,
    this.listId,
    this.color,
    this.size,
    this.status,
  });
  final int quantity;
  final String cartItemId;
  final List<SelectedShippingEntity> selectedShipping;
  final String? postId;
  final String? listId;
  final String? color;
  final String? size;
  final CartItemStatusType? status;
}

class SelectedShippingEntity {
  SelectedShippingEntity({
    required this.parcel,
    required this.serviceName,
    required this.rateObjectId,
    required this.parcelIndex,
    required this.convertedCurrency,
    required this.nativeBufferAmount,
    required this.toAddress,
    required this.parcelId,
    required this.shipmentId,
    required this.provider,
    required this.convertedBufferAmount,
    required this.fastDelivery,
    required this.deliveryType,
    required this.nativeCurrency,
    required this.coreAmount,
    required this.fromAddress,
    required this.serviceToken,
  });
  final ParcelEntity parcel;
  final String serviceName;
  final String rateObjectId;
  final int parcelIndex;
  final String convertedCurrency;
  final double nativeBufferAmount;
  final AddressEntity toAddress;
  final String parcelId;
  final String shipmentId;
  final String provider;
  final double convertedBufferAmount;
  final FastDeliveryEntity fastDelivery;
  final String deliveryType;
  final String nativeCurrency;
  final double coreAmount;
  final AddressEntity fromAddress;
  final String serviceToken;
}

class ParcelEntity {
  ParcelEntity({
    required this.length,
    required this.width,
    required this.distanceUnit,
    required this.weight,
    required this.massUnit,
    required this.height,
  });
  final String length;
  final String width;
  final String distanceUnit;
  final String weight;
  final String massUnit;
  final String height;
}
