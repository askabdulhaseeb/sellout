import 'package:hive_ce/hive.dart';
import '../../../../../../core/enums/core/status_type.dart';
import '../../../../../../core/sources/api_call.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../payment/domain/entities/exchange_rate_entity.dart';
import '../../../../payment/domain/params/get_exchange_rate_params.dart';
import '../../../../payment/domain/usecase/get_exchange_rate_usecase.dart';
import '../../../../home/view/enums/counter_offer_enum.dart';
part 'offer_detail_entity.g.dart';

@HiveType(typeId: 19)
class OfferDetailEntity {
  OfferDetailEntity({
    required this.postTitle,
    required this.size,
    required this.color,
    required this.price,
    required this.minOfferAmount,
    required this.currency,
    required this.offerId,
    required this.offerPrice,
    required this.offerStatus,
    required this.quantity,
    required this.buyerId,
    required this.sellerId,
    required this.postId,
    required this.counterBy,
    required this.counterAmount,
    required this.counterCurrency,
  });

  /// Returns the offer price string in user's currency for this offer
  Future<String> getOfferPriceStr() async {
    final double? converted = await getOfferLocalPrice();
    if (converted == null) return 'na';
    return '${converted.toStringAsFixed(2)} ${LocalAuth.currency}';
  }

  /// Returns the offer price converted to user's currency for this offer
  Future<double?> getOfferLocalPrice() async {
    // If you have access to CountryHelper and LocalAuth, use them
    final String from = currency;
    final String to = LocalAuth.currency;
    final double total = offerPrice * quantity.toDouble();
    if (from == to) return total;
    // If you have GetExchangeRateParams, GetExchangeRateUsecase, and locator()
    try {
      final GetExchangeRateParams params = GetExchangeRateParams(
        from: from,
        to: to,
      );
      final DataState<ExchangeRateEntity> result = await GetExchangeRateUsecase(
        locator(),
      ).call(params);
      if (result is DataSuccess) {
        return total * result.entity!.rate;
      }
    } catch (_) {}
    return null;
  }

  @HiveField(0)
  final String postTitle;
  @HiveField(1)
  final String size;
  @HiveField(2)
  final String color;
  @HiveField(4)
  final int price;
  @HiveField(5)
  final int minOfferAmount;
  @HiveField(6)
  StatusType? offerStatus;
  @HiveField(7)
  final String currency;
  @HiveField(8)
  final String offerId;
  @HiveField(9)
  int offerPrice;
  @HiveField(10)
  int quantity;
  @HiveField(11)
  final String buyerId;
  @HiveField(12)
  final String sellerId;
  @HiveField(13)
  final String postId;
  @HiveField(14)
  final CounterOfferEnum? counterBy;
  @HiveField(15)
  final int? counterAmount;
  @HiveField(16)
  final String? counterCurrency;
}
