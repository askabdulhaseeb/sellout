import '../../../../auth/signin/data/models/address_model.dart';
import '../../../domain/entities/cart/postage_detail_response_entity.dart';

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
      detail: json['detail'] == null
          ? {}
          : Map<String, PostageItemDetailEntity>.from(
              (json['detail'] as Map).map(
                (key, value) => MapEntry(
                  key as String,
                  PostageItemDetailModel.fromJson(value is Map<String, dynamic>
                      ? value
                      : <String, dynamic>{}),
                ),
              ),
            ),
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
        'detail': detail.map((key, value) =>
            MapEntry(key, (value as PostageItemDetailModel).toJson())),
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
    required super.id,
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
      id: json['id'] ?? '',
      packageDetail: json['package_detail'] is Map<String, dynamic>
          ? json['package_detail']
          : <String, dynamic>{},
      fromAddress: AddressModel.fromJson(
          json['fromAddress'] is Map<String, dynamic>
              ? json['fromAddress']
              : <String, dynamic>{}),
      toAddress: AddressModel.fromJson(json['toAddress'] is Map<String, dynamic>
          ? json['toAddress']
          : <String, dynamic>{}),
      sellerId: json['seller_id'],
      itemCount: json['item_count'] ?? 0,
      totalQuantity: json['total_quantity'] ?? 0,
      parcelCount: json['parcel_count'] ?? 0,
      packagingStrategy: json['packaging_strategy'] ?? '',
      originalDeliveryType: json['original_delivery_type'] ?? '',
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
        'id': id,
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
    required super.provider,
    required super.providerImage75,
    required super.providerImage200,
    required super.amountBuffered,
    required super.serviceLevel,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      amount: json['amount'] ?? '',
      provider: json['provider'] ?? '',
      providerImage75: json['providerImage75'] ?? '',
      providerImage200: json['providerImage200'] ?? '',
      amountBuffered: json['amountBuffered'] ?? '',
      serviceLevel: ServiceLevelModel.fromJson(
          json['servicelevel'] is Map<String, dynamic>
              ? json['servicelevel']
              : <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount': amount,
        'provider': provider,
        'providerImage75': providerImage75,
        'providerImage200': providerImage200,
        'amountBuffered': amountBuffered,
        'servicelevel': (serviceLevel as ServiceLevelModel).toJson(),
      };
}

class ServiceLevelModel extends ServiceLevelEntity {
  ServiceLevelModel({required super.name, required super.token});

  factory ServiceLevelModel.fromJson(Map<String, dynamic> json) {
    return ServiceLevelModel(
      name: json['name'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'token': token,
      };
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
