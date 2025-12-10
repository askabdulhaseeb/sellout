import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../personal/auth/signin/domain/entities/address_entity.dart';
import '../../../personal/payment/domain/entities/exchange_rate_entity.dart';
import '../../../personal/payment/domain/params/get_exchange_rate_params.dart';
import '../../../personal/payment/domain/usecase/get_exchange_rate_usecase.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../services/get_it.dart';

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
  final List<PostageItemDetailEntity> detail;
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
    required this.cartItemId,
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
  final String cartItemId;
  final Map<String, dynamic> packageDetail;
  final AddressEntity fromAddress;
  final AddressEntity toAddress;
  final String? sellerId;
  final int itemCount;
  final int totalQuantity;
  final int parcelCount;
  final String packagingStrategy;
  final DeliveryType originalDeliveryType;
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
    required this.amountLocal,
    required this.currency,
    required this.currencyLocal,
    required this.attributes,
    required this.carrierAccount,
    required this.durationTerms,
    required this.messages,
    required this.objectCreated,
    required this.objectId,
    required this.objectOwner,
    required this.provider,
    required this.providerImage75,
    required this.providerImage200,
    required this.serviceLevel,
    required this.shipment,
    required this.test,
    required this.zone,
    required this.originalAmount,
    required this.bufferedAmount,
    required this.bufferApplied,
    required this.bufferDetails,
    required this.amountBuffered,
    required this.amountLocalBuffered,
  });

  final String amount;
  final String amountLocal;
  final String currency;
  final String currencyLocal;
  final List<String> attributes;
  final String carrierAccount;
  final String durationTerms;
  final List<String> messages;
  final String objectCreated;
  final String objectId;
  final String objectOwner;
  final String provider;
  final String providerImage75;
  final String providerImage200;
  final ServiceLevelEntity serviceLevel;
  final String shipment;
  final bool test;
  final String zone;
  final String originalAmount;
  final String bufferedAmount;
  final String bufferApplied;
  final BufferDetailsEntity bufferDetails;
  final String amountBuffered;
  final String amountLocalBuffered;
  Future<double?> getLocalPrice() async {
    // provider currency
    final String from = currency;
    // user’s local currency
    final String to = LocalAuth.currency;

    // parse buffered amount to double
    final double buffered =
        double.tryParse(amountBuffered) ??
        double.tryParse(bufferedAmount) ??
        0.0;

    if (from == to) {
      // same currency, return buffered amount
      return buffered;
    }

    // different currency, get exchange rate
    final GetExchangeRateParams params = GetExchangeRateParams(
      from: from,
      to: to,
    );
    final DataState<ExchangeRateEntity> result = await GetExchangeRateUsecase(
      locator(),
    ).call(params);

    if (result is DataSuccess<ExchangeRateEntity> && result.entity != null) {
      return buffered * result.entity!.rate; // convert to local currency
    }

    return null; // conversion failed
  }

  Future<String> getPriceStr() async {
    final double? converted = await getLocalPrice();
    if (converted == null) return 'na'.tr();

    return '${CountryHelper.currencySymbolHelper(LocalAuth.currency)}'
        '${converted.toStringAsFixed(2)}';
  }
}

class ServiceLevelEntity {
  ServiceLevelEntity({
    required this.name,
    required this.terms,
    required this.token,
    required this.extendedToken,
  });

  final String name;
  final String terms;
  final String token;
  final String extendedToken;
}

class BufferDetailsEntity {
  BufferDetailsEntity({
    required this.bufferPercent,
    required this.bufferFlat,
    required this.minBuffer,
    required this.roundTo,
    this.maxBuffer,
  });

  final double bufferPercent;
  final double bufferFlat;
  final double minBuffer;
  final double? maxBuffer;
  final double roundTo;
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
