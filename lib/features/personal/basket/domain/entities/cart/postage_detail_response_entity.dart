import '../../../../auth/signin/domain/entities/address_entity.dart';

class PostageDetailResponseEntity {
  PostageDetailResponseEntity({
    required this.success,
    required this.summary,
    required this.detail,
    required this.cachedAt,
    required this.cacheKey,
  });

  final bool success;
  final PostageDetailSummaryEntity summary;
  final Map<String, PostageItemDetailEntity> detail;
  final String cachedAt;
  final String cacheKey;
}

class PostageDetailSummaryEntity {
  PostageDetailSummaryEntity({
    required this.totalPosts,
    required this.totalItems,
    required this.totalQuantityOfAllProducts,
    required this.fastDeliveryRequested,
    required this.fastDeliveryItemsCount,
    required this.successfulCalculations,
    required this.failedCalculations,
  });

  final int totalPosts;
  final int totalItems;
  final int totalQuantityOfAllProducts;
  final bool fastDeliveryRequested;
  final int fastDeliveryItemsCount;
  final int successfulCalculations;
  final int failedCalculations;
}

class PostageItemDetailEntity {
  PostageItemDetailEntity({
    required this.postId,
    required this.id,
    required this.packageDetail,
    required this.fromAddress,
    required this.toAddress,
    required this.sellerId,
    required this.itemCount,
    required this.totalQuantity,
    required this.parcelCount,
    required this.packagingStrategy,
    required this.originalDeliveryType,
    required this.deliveryRequirements,
    required this.shippingDetails,
    required this.fastDelivery,
    required this.message,
  });

  final String postId;
  final String id;
  final Map<String, dynamic> packageDetail; // keep as map for flexibility
  final AddressEntity fromAddress;
  final AddressEntity toAddress;
  final String? sellerId;
  final int itemCount;
  final int totalQuantity;
  final int parcelCount;
  final String packagingStrategy;
  final String originalDeliveryType;
  final PostageDetailDeliveryRequirementsEntity deliveryRequirements;
  final List<PostageDetailShippingDetailEntity> shippingDetails;
  final FastDeliveryEntity fastDelivery;
  final String? message;
}

class PostageDetailDeliveryRequirementsEntity {
  PostageDetailDeliveryRequirementsEntity({
    required this.hasFastDeliveryItems,
    required this.hasRegularItems,
    required this.fastDeliveryItemIds,
  });

  final bool hasFastDeliveryItems;
  final bool hasRegularItems;
  final List<String> fastDeliveryItemIds;
}

class PostageDetailShippingDetailEntity {
  PostageDetailShippingDetailEntity({
    required this.index,
    required this.parcelId,
    required this.shipmentId,
    required this.ratesBuffered,
    required this.parcel,
  });

  final int index;
  final String parcelId;
  final String shipmentId;
  final List<RateEntity> ratesBuffered;
  final ParcelEntity parcel;
}

class RateEntity {
  RateEntity({
    required this.amount,
    required this.provider,
    required this.providerImage75,
    required this.providerImage200,
    required this.amountBuffered,
    required this.serviceLevel,
  });

  final String amount;
  final String provider;
  final String providerImage75;
  final String providerImage200;
  final String amountBuffered;
  final ServiceLevelEntity serviceLevel;
}

class ServiceLevelEntity {
  ServiceLevelEntity({required this.name, required this.token});

  final String name;
  final String token;
}

class ParcelEntity {
  ParcelEntity({
    required this.length,
    required this.width,
    required this.height,
    required this.distanceUnit,
    required this.weight,
    required this.massUnit,
  });

  final String length;
  final String width;
  final String height;
  final String distanceUnit;
  final String weight;
  final String massUnit;
}

class FastDeliveryEntity {
  FastDeliveryEntity({
    required this.requested,
    required this.available,
    required this.message,
  });

  final bool requested;
  final bool available;
  final String? message;
}
