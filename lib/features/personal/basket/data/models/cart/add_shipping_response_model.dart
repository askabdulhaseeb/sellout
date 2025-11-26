import '../../../../../../core/enums/cart/cart_item_type.dart';
import '../../../domain/entities/cart/added_shipping_response_entity.dart';

class AddShippingResponseModel extends AddedShippingResponseEntity {
  factory AddShippingResponseModel.fromJson(Map<String, dynamic> json) {
    return AddShippingResponseModel(
      message: json['message']?.toString() ?? '',
      cartModel: AddShippingCartModel.fromJson(
        json['cart'] is Map<String, dynamic>
            ? json['cart'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }
  AddShippingResponseModel({
    required this.cartModel,
    required super.message,
  }) : super(cart: cartModel);

  final AddShippingCartModel cartModel;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'cart': cartModel.toJson(),
      };
}

class AddShippingCartModel extends AddShippingCartEntity {

  factory AddShippingCartModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems = json['cart_items'] is List
        ? json['cart_items'] as List<dynamic>
        : <dynamic>[];
    return AddShippingCartModel(
      updatedAt: json['updated_at']?.toString() ?? '',
      items: rawItems
          .map((dynamic item) => AddShippingCartItemModel.fromJson(
                item is Map<String, dynamic> ? item : <String, dynamic>{},
              ))
          .toList(),
    );
  }
  AddShippingCartModel({
    required super.updatedAt,
    required List<AddShippingCartItemModel> items,
  })  : cartItemsModel = items,
        super(cartItems: items);

  final List<AddShippingCartItemModel> cartItemsModel;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'updated_at': updatedAt,
        'cart_items': cartItemsModel
            .map((AddShippingCartItemModel e) => e.toJson())
            .toList(),
      };
}

class AddShippingCartItemModel extends AddShippingCartItemEntity {

  factory AddShippingCartItemModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawSelected = json['selected_shipping'] is List
        ? json['selected_shipping'] as List<dynamic>
        : <dynamic>[];
    return AddShippingCartItemModel(
      quantity: _parseInt(json['quantity']),
      cartItemId: json['cart_item_id']?.toString() ?? '',
      selected: rawSelected
          .map((dynamic item) => SelectedShippingModel.fromJson(
                item is Map<String, dynamic> ? item : <String, dynamic>{},
              ))
          .toList(),
      postId: json['post_id']?.toString() ?? '',
      listId: json['list_id']?.toString() ?? '',
      status: CartItemStatusType.fromJson(json['status']?.toString() ?? ''),
      color: json['color']?.toString(),
      size: json['size']?.toString(),
    );
  }
  AddShippingCartItemModel({
    required super.quantity,
    required super.cartItemId,
    required List<SelectedShippingModel> selected,
    required super.postId,
    required super.listId,
    required super.status,
    super.color,
    super.size,
  })  : selectedShippingModel = selected,
        super(selectedShipping: selected);

  final List<SelectedShippingModel> selectedShippingModel;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'quantity': quantity,
        'cart_item_id': cartItemId,
        'selected_shipping': selectedShippingModel
            .map((SelectedShippingModel e) => e.toJson())
            .toList(),
        'post_id': postId,
        'list_id': listId,
        'status': status,
        if (color != null) 'color': color,
        if (size != null) 'size': size,
      };
}

class SelectedShippingModel extends SelectedShippingEntity {

  factory SelectedShippingModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> jsonCopy = Map<String, dynamic>.from(json);
    final ShippingAddressModel? from =
        jsonCopy['from_address'] is Map<String, dynamic>
            ? ShippingAddressModel.fromJson(
                jsonCopy['from_address'] as Map<String, dynamic>)
            : null;
    final ShippingAddressModel? to =
        jsonCopy['to_address'] is Map<String, dynamic>
            ? ShippingAddressModel.fromJson(
                jsonCopy['to_address'] as Map<String, dynamic>)
            : null;
    final SelectedShippingParcelModel? parcel =
        jsonCopy['parcel'] is Map<String, dynamic>
            ? SelectedShippingParcelModel.fromJson(
                jsonCopy['parcel'] as Map<String, dynamic>)
            : null;
    final SelectedShippingFastDeliveryModel? fastDelivery =
        jsonCopy['fast_delivery'] is Map<String, dynamic>
            ? SelectedShippingFastDeliveryModel.fromJson(
                jsonCopy['fast_delivery'] as Map<String, dynamic>,
              )
            : null;

    const Set<String> knownKeys = <String>{
      'from_address',
      'to_address',
      'delivery_type',
      'service_name',
      'rate_object_id',
      'parcel_index',
      'converted_currency',
      'native_buffer_amount',
      'parcel',
      'parcel_id',
      'shipment_id',
      'provider',
      'converted_buffer_amount',
      'fast_delivery',
      'native_currency',
      'core_amount',
      'service_token',
      'note',
      'packaging_strategy',
      'parcel_count',
    };

    final Map<String, dynamic> additional = Map<String, dynamic>.from(jsonCopy)
      ..removeWhere((String key, dynamic value) => knownKeys.contains(key));

    return SelectedShippingModel(
      from: from,
      to: to,
      deliveryType: json['delivery_type']?.toString() ?? '',
      serviceName: json['service_name']?.toString(),
      rateObjectId: json['rate_object_id']?.toString(),
      parcelIndex: _parseNullableInt(json['parcel_index']),
      convertedCurrency: json['converted_currency']?.toString(),
      nativeBufferAmount: _parseNullableDouble(json['native_buffer_amount']),
      parcel: parcel,
      parcelId: json['parcel_id']?.toString(),
      shipmentId: json['shipment_id']?.toString(),
      provider: json['provider']?.toString(),
      convertedBufferAmount:
          _parseNullableDouble(json['converted_buffer_amount']),
      fastDelivery: fastDelivery,
      nativeCurrency: json['native_currency']?.toString(),
      coreAmount: _parseNullableDouble(json['core_amount']),
      serviceToken: json['service_token']?.toString(),
      note: json['note']?.toString(),
      packagingStrategy: json['packaging_strategy']?.toString(),
      parcelCount: _parseNullableInt(json['parcel_count']),
      additionalData: additional.isEmpty ? null : additional,
    );
  }
  SelectedShippingModel({
    required super.deliveryType, ShippingAddressModel? from,
    ShippingAddressModel? to,
    super.serviceName,
    super.rateObjectId,
    super.parcelIndex,
    super.convertedCurrency,
    super.nativeBufferAmount,
    SelectedShippingParcelModel? parcel,
    super.parcelId,
    super.shipmentId,
    super.provider,
    super.convertedBufferAmount,
    SelectedShippingFastDeliveryModel? fastDelivery,
    super.nativeCurrency,
    super.coreAmount,
    super.serviceToken,
    super.note,
    super.packagingStrategy,
    super.parcelCount,
    super.additionalData,
  })  : fromAddressModel = from,
        toAddressModel = to,
        parcelModel = parcel,
        fastDeliveryModel = fastDelivery,
        super(
          fromAddress: from,
          toAddress: to,
          parcel: parcel,
          fastDelivery: fastDelivery,
        );

  final ShippingAddressModel? fromAddressModel;
  final ShippingAddressModel? toAddressModel;
  final SelectedShippingParcelModel? parcelModel;
  final SelectedShippingFastDeliveryModel? fastDeliveryModel;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'delivery_type': deliveryType,
      if (serviceName != null) 'service_name': serviceName,
      if (rateObjectId != null) 'rate_object_id': rateObjectId,
      if (parcelIndex != null) 'parcel_index': parcelIndex,
      if (convertedCurrency != null) 'converted_currency': convertedCurrency,
      if (nativeBufferAmount != null)
        'native_buffer_amount': nativeBufferAmount,
      if (parcelId != null) 'parcel_id': parcelId,
      if (shipmentId != null) 'shipment_id': shipmentId,
      if (provider != null) 'provider': provider,
      if (convertedBufferAmount != null)
        'converted_buffer_amount': convertedBufferAmount,
      if (nativeCurrency != null) 'native_currency': nativeCurrency,
      if (coreAmount != null) 'core_amount': coreAmount,
      if (serviceToken != null) 'service_token': serviceToken,
      if (note != null) 'note': note,
      if (packagingStrategy != null) 'packaging_strategy': packagingStrategy,
      if (parcelCount != null) 'parcel_count': parcelCount,
    };

    if (fromAddressModel != null) {
      data['from_address'] = fromAddressModel!.toJson();
    }
    if (toAddressModel != null) {
      data['to_address'] = toAddressModel!.toJson();
    }
    if (parcelModel != null) {
      data['parcel'] = parcelModel!.toJson();
    }
    if (fastDeliveryModel != null) {
      data['fast_delivery'] = fastDeliveryModel!.toJson();
    }
    if (additionalData != null) {
      data.addAll(additionalData!);
    }
    return data;
  }
}

class ShippingAddressModel extends ShippingAddressEntity {
  ShippingAddressModel({
    super.zip,
    super.country,
    super.city,
    super.phone,
    super.name,
    super.street1,
    super.state,
    super.email,
    super.address1,
    super.addressCategory,
    super.phoneNumber,
    super.recipientName,
    super.postalCode,
    super.isDefault,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      zip: json['zip']?.toString(),
      country: json['country']?.toString(),
      city: json['city']?.toString(),
      phone: json['phone']?.toString(),
      name: json['name']?.toString(),
      street1: json['street1']?.toString(),
      state: json['state']?.toString(),
      email: json['email']?.toString(),
      address1: json['address_1']?.toString(),
      addressCategory: json['address_category']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      recipientName: json['recipient_name']?.toString(),
      postalCode: json['postal_code']?.toString(),
      isDefault: _parseNullableBool(json['is_default']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (zip != null) 'zip': zip,
        if (country != null) 'country': country,
        if (city != null) 'city': city,
        if (phone != null) 'phone': phone,
        if (name != null) 'name': name,
        if (street1 != null) 'street1': street1,
        if (state != null) 'state': state,
        if (email != null) 'email': email,
        if (address1 != null) 'address_1': address1,
        if (addressCategory != null) 'address_category': addressCategory,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (recipientName != null) 'recipient_name': recipientName,
        if (postalCode != null) 'postal_code': postalCode,
        if (isDefault != null) 'is_default': isDefault,
      };
}

class SelectedShippingParcelModel extends SelectedShippingParcelEntity {
  SelectedShippingParcelModel({
    super.length,
    super.width,
    super.height,
    super.distanceUnit,
    super.weight,
    super.massUnit,
  });

  factory SelectedShippingParcelModel.fromJson(Map<String, dynamic> json) {
    return SelectedShippingParcelModel(
      length: json['length']?.toString(),
      width: json['width']?.toString(),
      height: json['height']?.toString(),
      distanceUnit: json['distanceUnit']?.toString(),
      weight: json['weight']?.toString(),
      massUnit: json['massUnit']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (length != null) 'length': length,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (distanceUnit != null) 'distanceUnit': distanceUnit,
        if (weight != null) 'weight': weight,
        if (massUnit != null) 'massUnit': massUnit,
      };
}

class SelectedShippingFastDeliveryModel
    extends SelectedShippingFastDeliveryEntity {
  SelectedShippingFastDeliveryModel({
    required super.available,
    required super.requested,
    super.message,
  });

  factory SelectedShippingFastDeliveryModel.fromJson(
      Map<String, dynamic> json) {
    return SelectedShippingFastDeliveryModel(
      available: _parseBool(json['available']),
      requested: _parseBool(json['requested']),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'available': available,
        'requested': requested,
        if (message != null) 'message': message,
      };
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  if (value is double) {
    return value.toInt();
  }
  return 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is double) {
    return value.toInt();
  }
  return null;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  if (value is num) {
    return value != 0;
  }
  return false;
}

bool? _parseNullableBool(dynamic value) {
  if (value == null) {
    return null;
  }
  return _parseBool(value);
}
