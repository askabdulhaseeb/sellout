import 'package:hive/hive.dart';
import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../payment/domain/entities/exchange_rate_entity.dart';
import '../../../../payment/domain/params/get_exchange_rate_params.dart';
import '../../../../payment/domain/usecase/get_exchange_rate_usecase.dart';
import '../discount_entity.dart';
import '../meetup/availability_entity.dart';
import 'package_detail_entity.dart';
import 'post_cloth_foot_entity.dart';
import 'post_food_drink_entity.dart';
import 'post_item_entity.dart';
import 'post_pet_entity.dart';
import 'post_property_entity.dart';
import 'post_vehicle_entity.dart';
part 'post_entity.g.dart';

@HiveType(typeId: 20)
class PostEntity {
  PostEntity({
    required this.listID,
    required this.postID,
    required this.businessID,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.currency,
    required this.type,
    required this.acceptOffers,
    required this.minOfferAmount,
    required this.privacy,
    required this.condition,
    required this.listOfReviews,
    required this.categoryType,
    // Location
    required this.currentLongitude,
    required this.currentLatitude,
    required this.collectionLatitude,
    required this.collectionLongitude,
    required this.collectionLocation,
    required this.meetUpLocation,
    // Delivery
    required this.deliveryType,
    required this.localDelivery,
    required this.internationalDelivery,
    // Availability
    required this.availability,
    // Attachments
    required this.fileUrls,
    // Discount
    required this.hasDiscount,
    required this.discount,
    // Cloth Foot
    required this.clothFootInfo,
    // Property
    required this.propertyInfo,
    // Pets
    required this.petInfo,
    // Vehicle
    required this.vehicleInfo,
    // Food Drink
    required this.foodDrinkInfo,
    // Item
    required this.itemInfo,
    // Package Detail
    required this.packageDetail,
    // Other fields
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.accessCode,
    DateTime? inHiveAt,
  }) : inHiveAt = inHiveAt ?? DateTime.now();

  @HiveField(0)
  final String listID;
  @HiveField(1)
  final String postID;
  @HiveField(2)
  final String? businessID;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final double price;
  @HiveField(6)
  final int quantity;
  @HiveField(7)
  final String? currency;
  @HiveField(8)
  final ListingType type;
  @HiveField(10)
  final bool acceptOffers;
  @HiveField(11)
  final double minOfferAmount;
  @HiveField(12)
  final PrivacyType privacy;
  @HiveField(13)
  final ConditionType condition;
  @HiveField(14)
  final DeliveryType deliveryType;
  @HiveField(15)
  final List<double>? listOfReviews;
  @HiveField(16)
  final String categoryType;
  @HiveField(17)
  final List<AttachmentEntity> fileUrls;
  //
  @HiveField(18)
  final DiscountEntity? discount;
  @HiveField(19)
  final bool hasDiscount;
  //
  @HiveField(20)
  final double currentLongitude;
  @HiveField(21)
  final double currentLatitude;
  @HiveField(22)
  final double collectionLatitude;
  @HiveField(23)
  final double collectionLongitude;
  @HiveField(24)
  final LocationEntity? collectionLocation;
  @HiveField(25)
  final LocationEntity? meetUpLocation;
  //
  @HiveField(26)
  final int? localDelivery;
  @HiveField(27)
  final int? internationalDelivery;
  //
  @HiveField(28)
  final PostClothFootEntity? clothFootInfo;
  //
  @HiveField(29)
  final PostVehicleEntity? vehicleInfo;
  //
  @HiveField(30)
  final PostPetEntity? petInfo;
  //
  @HiveField(31)
  final PostPropertyEntity? propertyInfo;
  //
  @HiveField(32)
  final PostFoodDrinkEntity? foodDrinkInfo;
  //
  @HiveField(33)
  final PostItemEntity? itemInfo;

  @HiveField(34) // NEW FIELD - Package Detail
  final PackageDetailEntity packageDetail;
  //
  @HiveField(35)
  final List<AvailabilityEntity>? availability;
  @HiveField(36)
  final bool isActive;
  @HiveField(37)
  final String createdBy;
  @HiveField(38)
  final DateTime createdAt;
  @HiveField(39)
  final String? accessCode;
  @HiveField(40, defaultValue: '')
  final String updatedBy;
  @HiveField(41, defaultValue: null)
  final DateTime? updatedAt;
  @HiveField(42)
  final DateTime inHiveAt;

  String get imageURL => fileUrls.isEmpty ? '' : fileUrls.first.url;
  String get priceStr =>
      '${CountryHelper.currencySymbolHelper(currency)}$price'.toUpperCase();

  // Package detail helper methods
  String get packageDimensions =>
      '${packageDetail.length}L x ${packageDetail.width}W x ${packageDetail.height}H';

  Future<double?> getLocalPrice(GetExchangeRateUsecase usecase) async {
    final String fromCurrency = currency ?? 'GBP';
    final String toCurrency = LocalAuth.currency;
    if (fromCurrency == toCurrency) return price;

    final GetExchangeRateParams params = GetExchangeRateParams(
      from: fromCurrency,
      to: toCurrency,
    );
    final DataState<ExchangeRateEntity> result = await usecase(params);
    if (result is DataSuccess<ExchangeRateEntity>) {
      return price * result.entity!.rate;
    }
    return null;
  }
}
