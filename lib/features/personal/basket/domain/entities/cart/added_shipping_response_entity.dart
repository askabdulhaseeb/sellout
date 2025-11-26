import '../../../../../../core/enums/cart/cart_item_type.dart';

class AddedShippingResponseEntity {
  AddedShippingResponseEntity({
    required this.message,
    required this.cart,
  });

  final String message;
  final AddShippingCartEntity cart;
}

class AddShippingCartEntity {
  AddShippingCartEntity({
    required this.updatedAt,
    required this.cartItems,
  });

  final String updatedAt;
  final List<AddShippingCartItemEntity> cartItems;
}

class AddShippingCartItemEntity {
  AddShippingCartItemEntity({
    required this.quantity,
    required this.cartItemId,
    required this.selectedShipping,
    required this.postId,
    required this.listId,
    required this.status,
    this.color,
    this.size,
  });

  final int quantity;
  final String cartItemId;
  final List<SelectedShippingEntity> selectedShipping;
  final String postId;
  final String listId;
  final CartItemStatusType status;
  final String? color;
  final String? size;
}

class SelectedShippingEntity {
  SelectedShippingEntity({
    this.fromAddress,
    this.toAddress,
    required this.deliveryType,
    this.serviceName,
    this.rateObjectId,
    this.parcelIndex,
    this.convertedCurrency,
    this.nativeBufferAmount,
    this.parcel,
    this.parcelId,
    this.shipmentId,
    this.provider,
    this.convertedBufferAmount,
    this.fastDelivery,
    this.nativeCurrency,
    this.coreAmount,
    this.serviceToken,
    this.note,
    this.packagingStrategy,
    this.parcelCount,
    this.additionalData,
  });

  final ShippingAddressEntity? fromAddress;
  final ShippingAddressEntity? toAddress;
  final String deliveryType;
  final String? serviceName;
  final String? rateObjectId;
  final int? parcelIndex;
  final String? convertedCurrency;
  final double? nativeBufferAmount;
  final SelectedShippingParcelEntity? parcel;
  final String? parcelId;
  final String? shipmentId;
  final String? provider;
  final double? convertedBufferAmount;
  final SelectedShippingFastDeliveryEntity? fastDelivery;
  final String? nativeCurrency;
  final double? coreAmount;
  final String? serviceToken;
  final String? note;
  final String? packagingStrategy;
  final int? parcelCount;
  final Map<String, dynamic>? additionalData;
}

class ShippingAddressEntity {
  ShippingAddressEntity({
    this.zip,
    this.country,
    this.city,
    this.phone,
    this.name,
    this.street1,
    this.state,
    this.email,
    this.address1,
    this.addressCategory,
    this.phoneNumber,
    this.recipientName,
    this.postalCode,
    this.isDefault,
  });

  final String? zip;
  final String? country;
  final String? city;
  final String? phone;
  final String? name;
  final String? street1;
  final String? state;
  final String? email;
  final String? address1;
  final String? addressCategory;
  final String? phoneNumber;
  final String? recipientName;
  final String? postalCode;
  final bool? isDefault;
}

class SelectedShippingParcelEntity {
  SelectedShippingParcelEntity({
    this.length,
    this.width,
    this.height,
    this.distanceUnit,
    this.weight,
    this.massUnit,
  });

  final String? length;
  final String? width;
  final String? height;
  final String? distanceUnit;
  final String? weight;
  final String? massUnit;
}

class SelectedShippingFastDeliveryEntity {
  SelectedShippingFastDeliveryEntity({
    required this.available,
    required this.requested,
    this.message,
  });

  final bool available;
  final bool requested;
  final String? message;
}
