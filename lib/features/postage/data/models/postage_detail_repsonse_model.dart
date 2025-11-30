import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../personal/auth/signin/data/models/address_model.dart';
import '../../domain/entities/postage_detail_response_entity.dart';

class PostageDetailResponseModel extends PostageDetailResponseEntity {
  PostageDetailResponseModel({
    required super.success,
    required super.summary,
    required super.detail,
    required super.cachedAt,
    required super.cacheKey,
  });

  factory PostageDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return PostageDetailResponseModel(
      success: json['success'] ?? false,
      detail: json['detail'] != null && json['detail'] is Map
          ? (json['detail'] as Map<String, dynamic>)
              .values
              .map((e) => PostageItemDetailModel.fromJson(
                  e is Map<String, dynamic> ? e : <String, dynamic>{}))
              .toList()
          : <PostageItemDetailModel>[],
      summary: PostageDetailSummaryModel.fromJson(
          json['summary'] is Map<String, dynamic>
              ? json['summary']
              : <String, dynamic>{}),
      cachedAt: json['cached_at'] ?? '',
      cacheKey: json['cache_key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'summary': (summary as PostageDetailSummaryModel).toJson(),
        'detail':
            detail.map((e) => (e as PostageItemDetailModel).toJson()).toList(),
        'cached_at': cachedAt,
        'cache_key': cacheKey,
      };
}

class PostageDetailSummaryModel extends PostageDetailSummaryEntity {
  PostageDetailSummaryModel({
    required super.totalPosts,
    required super.totalItems,
    required super.totalQuantityOfAllProducts,
    required super.fastDeliveryRequested,
    required super.fastDeliveryItemsCount,
    required super.successfulCalculations,
    required super.failedCalculations,
  });

  factory PostageDetailSummaryModel.fromJson(Map<String, dynamic> json) {
    return PostageDetailSummaryModel(
      totalPosts: json['total_posts'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalQuantityOfAllProducts: json['total_quantity_of_all_products'] ?? 0,
      fastDeliveryRequested: json['fast_delivery_requested'] ?? false,
      fastDeliveryItemsCount: json['fast_delivery_items_count'] ?? 0,
      successfulCalculations: json['successful_calculations'] ?? 0,
      failedCalculations: json['failed_calculations'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total_posts': totalPosts,
        'total_items': totalItems,
        'total_quantity_of_all_products': totalQuantityOfAllProducts,
        'fast_delivery_requested': fastDeliveryRequested,
        'fast_delivery_items_count': fastDeliveryItemsCount,
        'successful_calculations': successfulCalculations,
        'failed_calculations': failedCalculations,
      };
}

class PostageItemDetailModel extends PostageItemDetailEntity {
  PostageItemDetailModel({
    required super.postId,
    required super.cartItemId,
    required super.packageDetail,
    required super.fromAddress,
    required super.toAddress,
    required super.sellerId,
    required super.itemCount,
    required super.totalQuantity,
    required super.parcelCount,
    required super.packagingStrategy,
    required super.originalDeliveryType,
    required super.deliveryRequirements,
    required super.shippingDetails,
    required super.fastDelivery,
    required super.message,
  });

  factory PostageItemDetailModel.fromJson(Map<String, dynamic> json) {
    return PostageItemDetailModel(
      postId: json['post_id'] ?? '',
      cartItemId: json['id'] ?? '',
      packageDetail: json['package_detail'] is Map<String, dynamic>
          ? json['package_detail']
          : <String, dynamic>{},
      fromAddress: AddressModel.fromJson(
          json['fromAddress']),
      toAddress: AddressModel.fromJson(json['toAddress'] is Map<String, dynamic>
          ? json['toAddress']
          : <String, dynamic>{}),
      sellerId: json['seller_id'] ?? '',
      itemCount: json['item_count'] ?? 0,
      totalQuantity: json['total_quantity'] ?? 0,
      parcelCount: json['parcel_count'] ?? 0,
      packagingStrategy: json['packaging_strategy'] ?? '',
      originalDeliveryType:
          DeliveryType.fromJson(json['original_delivery_type']),
      deliveryRequirements: PostageDetailDeliveryRequirementsModel.fromJson(
          json['delivery_requirements'] is Map<String, dynamic>
              ? json['delivery_requirements']
              : <String, dynamic>{}),
      shippingDetails: (json['shipping_details'] is List)
          ? (json['shipping_details'] as List<dynamic>)
              .map((e) => PostageDetailShippingDetailModel.fromJson(
                  e is Map<String, dynamic> ? e : <String, dynamic>{}))
              .toList()
          : <PostageDetailShippingDetailModel>[],
      fastDelivery: FastDeliveryModel.fromJson(
          json['fast_delivery'] is Map<String, dynamic>
              ? json['fast_delivery']
              : <String, dynamic>{}),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'post_id': postId,
        'id': cartItemId,
        'package_detail': packageDetail,
        'fromAddress': (fromAddress as AddressModel).toJson(),
        'toAddress': (toAddress as AddressModel).toJson(),
        'seller_id': sellerId,
        'item_count': itemCount,
        'total_quantity': totalQuantity,
        'parcel_count': parcelCount,
        'packaging_strategy': packagingStrategy,
        'original_delivery_type': originalDeliveryType,
        'delivery_requirements':
            (deliveryRequirements as PostageDetailDeliveryRequirementsModel)
                .toJson(),
        'shipping_details': shippingDetails
            .map((e) => (e as PostageDetailShippingDetailModel).toJson())
            .toList(),
        'fast_delivery': (fastDelivery as FastDeliveryModel).toJson(),
        'message': message,
      };
}

// ---------------------- OTHER MODELS (unchanged) ----------------------

class PostageDetailDeliveryRequirementsModel
    extends PostageDetailDeliveryRequirementsEntity {
  PostageDetailDeliveryRequirementsModel({
    required super.hasFastDeliveryItems,
    required super.hasRegularItems,
    required super.fastDeliveryItemIds,
  });

  factory PostageDetailDeliveryRequirementsModel.fromJson(
      Map<String, dynamic> json) {
    return PostageDetailDeliveryRequirementsModel(
      hasFastDeliveryItems: json['has_fast_delivery_items'] ?? false,
      hasRegularItems: json['has_regular_items'] ?? false,
      fastDeliveryItemIds: json['fast_delivery_item_ids'] is List
          ? List<String>.from(json['fast_delivery_item_ids'])
          : <String>[],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'has_fast_delivery_items': hasFastDeliveryItems,
        'has_regular_items': hasRegularItems,
        'fast_delivery_item_ids': fastDeliveryItemIds,
      };
}

class PostageDetailShippingDetailModel
    extends PostageDetailShippingDetailEntity {
  PostageDetailShippingDetailModel({
    required super.index,
    required super.parcelId,
    required super.shipmentId,
    required super.ratesBuffered,
    required super.parcel,
  });

  factory PostageDetailShippingDetailModel.fromJson(Map<String, dynamic> json) {
    return PostageDetailShippingDetailModel(
      index: json['index'] ?? 0,
      parcelId: json['parcelId'] ?? '',
      shipmentId: json['shipmentId'] ?? '',
      ratesBuffered: (json['ratesBuffered'] is List)
          ? (json['ratesBuffered'] as List)
              .map((e) => RateModel.fromJson(
                  e is Map<String, dynamic> ? e : <String, dynamic>{}))
              .toList()
          : <RateModel>[],
      parcel: ParcelModel.fromJson(json['parcel'] is Map<String, dynamic>
          ? json['parcel']
          : <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'index': index,
        'parcelId': parcelId,
        'shipmentId': shipmentId,
        'ratesBuffered':
            ratesBuffered.map((e) => (e as RateModel).toJson()).toList(),
        'parcel': (parcel as ParcelModel).toJson(),
      };
}

class RateModel extends RateEntity {
  RateModel({
    required super.amount,
    required super.amountLocal,
    required super.currency,
    required super.currencyLocal,
    required super.attributes,
    required super.carrierAccount,
    required super.durationTerms,
    required super.messages,
    required super.objectCreated,
    required super.objectId,
    required super.objectOwner,
    required super.provider,
    required super.providerImage75,
    required super.providerImage200,
    required super.serviceLevel,
    required super.shipment,
    required super.test,
    required super.zone,
    required super.originalAmount,
    required super.bufferedAmount,
    required super.bufferApplied,
    required super.bufferDetails,
    required super.amountBuffered,
    required super.amountLocalBuffered,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      amount: json['amount']?.toString() ?? '',
      amountLocal: json['amountLocal']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      currencyLocal: json['currencyLocal']?.toString() ?? '',
      attributes: _parseStringList(json['attributes']),
      carrierAccount: json['carrierAccount']?.toString() ?? '',
      durationTerms: json['durationTerms']?.toString() ?? '',
      messages: _parseStringList(json['messages']),
      objectCreated: json['objectCreated']?.toString() ?? '',
      objectId: json['objectId']?.toString() ?? '',
      objectOwner: json['objectOwner']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      providerImage75: json['providerImage75']?.toString() ?? '',
      providerImage200: json['providerImage200']?.toString() ?? '',
      serviceLevel: ServiceLevelModel.fromJson(
          json['servicelevel'] is Map<String, dynamic>
              ? json['servicelevel']
              : <String, dynamic>{}),
      shipment: json['shipment']?.toString() ?? '',
      test: json['test'] is bool
          ? json['test'] as bool
          : (json['test'] != null &&
              json['test'].toString().toLowerCase() == 'true'),
      zone: json['zone']?.toString() ?? '',
      originalAmount: json['originalAmount']?.toString() ?? '',
      bufferedAmount: json['bufferedAmount']?.toString() ?? '',
      bufferApplied: json['bufferApplied']?.toString() ?? '',
      bufferDetails: json['bufferDetails'] is Map<String, dynamic>
          ? BufferDetailsModel.fromJson(
              json['bufferDetails'] as Map<String, dynamic>,
            )
          : BufferDetailsModel.empty(),
      amountBuffered: json['amountBuffered']?.toString() ?? '',
      amountLocalBuffered: json['amountLocalBuffered']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount': amount,
        'amountLocal': amountLocal,
        'currency': currency,
        'currencyLocal': currencyLocal,
        'attributes': attributes,
        'carrierAccount': carrierAccount,
        'durationTerms': durationTerms,
        'messages': messages,
        'objectCreated': objectCreated,
        'objectId': objectId,
        'objectOwner': objectOwner,
        'provider': provider,
        'providerImage75': providerImage75,
        'providerImage200': providerImage200,
        'servicelevel': serviceLevel is ServiceLevelModel
            ? (serviceLevel as ServiceLevelModel).toJson()
            : ServiceLevelModel.fromEntity(serviceLevel).toJson(),
        'shipment': shipment,
        'test': test,
        'zone': zone,
        'originalAmount': originalAmount,
        'bufferedAmount': bufferedAmount,
        'bufferApplied': bufferApplied,
        'bufferDetails': bufferDetails is BufferDetailsModel
            ? (bufferDetails as BufferDetailsModel).toJson()
            : BufferDetailsModel.fromEntity(bufferDetails).toJson(),
        'amountBuffered': amountBuffered,
        'amountLocalBuffered': amountLocalBuffered,
      };
}

class BufferDetailsModel extends BufferDetailsEntity {
  BufferDetailsModel({
    required super.bufferPercent,
    required super.bufferFlat,
    required super.minBuffer,
    super.maxBuffer,
    required super.roundTo,
  });

  factory BufferDetailsModel.fromJson(Map<String, dynamic> json) {
    return BufferDetailsModel(
      bufferPercent: _parseDouble(json['bufferPercent']),
      bufferFlat: _parseDouble(json['bufferFlat']),
      minBuffer: _parseDouble(json['minBuffer']),
      maxBuffer: _parseNullableDouble(json['maxBuffer']),
      roundTo: _parseDouble(json['roundTo']),
    );
  }

  factory BufferDetailsModel.fromEntity(BufferDetailsEntity entity) {
    return BufferDetailsModel(
      bufferPercent: entity.bufferPercent,
      bufferFlat: entity.bufferFlat,
      minBuffer: entity.minBuffer,
      maxBuffer: entity.maxBuffer,
      roundTo: entity.roundTo,
    );
  }

  factory BufferDetailsModel.empty() {
    return BufferDetailsModel(
      bufferPercent: 0,
      bufferFlat: 0,
      minBuffer: 0,
      maxBuffer: null,
      roundTo: 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bufferPercent': bufferPercent,
        'bufferFlat': bufferFlat,
        'minBuffer': minBuffer,
        'maxBuffer': maxBuffer,
        'roundTo': roundTo,
      };
}

class ServiceLevelModel extends ServiceLevelEntity {
  ServiceLevelModel({
    required super.name,
    required super.terms,
    required super.token,
    required super.extendedToken,
  });

  factory ServiceLevelModel.fromJson(Map<String, dynamic> json) {
    return ServiceLevelModel(
      name: json['name'] ?? '',
      terms: json['terms'] ?? '',
      token: json['token'] ?? '',
      extendedToken: json['extendedToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'terms': terms,
        'token': token,
        'extendedToken': extendedToken,
      };

  factory ServiceLevelModel.fromEntity(ServiceLevelEntity entity) {
    return ServiceLevelModel(
      name: entity.name,
      terms: entity.terms,
      token: entity.token,
      extendedToken: entity.extendedToken,
    );
  }
}

class ParcelModel extends ParcelEntity {
  ParcelModel({
    required super.length,
    required super.width,
    required super.height,
    required super.distanceUnit,
    required super.weight,
    required super.massUnit,
  });

  factory ParcelModel.fromJson(Map<String, dynamic> json) {
    return ParcelModel(
      length: json['length'] ?? '',
      width: json['width'] ?? '',
      height: json['height'] ?? '',
      distanceUnit: json['distanceUnit'] ?? '',
      weight: json['weight'] ?? '',
      massUnit: json['massUnit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'length': length,
        'width': width,
        'height': height,
        'distanceUnit': distanceUnit,
        'weight': weight,
        'massUnit': massUnit,
      };
}

class FastDeliveryModel extends FastDeliveryEntity {
  FastDeliveryModel({
    required super.requested,
    required super.available,
    required super.message,
  });

  factory FastDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FastDeliveryModel(
      requested: json['requested'] ?? false,
      available: json['available'] ?? false,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'requested': requested,
        'available': available,
        'message': message,
      };
}

List<String> _parseStringList(dynamic value) {
  if (value is List) {
    return value
        .map((dynamic item) => item == null ? '' : item.toString())
        .toList();
  }
  return <String>[];
}

double _parseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
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
