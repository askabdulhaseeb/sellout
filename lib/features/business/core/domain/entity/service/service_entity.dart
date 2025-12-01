import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../../personal/payment/domain/entities/exchange_rate_entity.dart';
import '../../../../../personal/payment/domain/params/get_exchange_rate_params.dart';
import '../../../../../personal/payment/domain/usecase/get_exchange_rate_usecase.dart';
import '../business_employee_entity.dart';
part 'service_entity.g.dart';

@HiveType(typeId: 46)
class ServiceEntity {
  ServiceEntity({
    required this.businessID,
    required this.serviceID,
    required this.name,
    required this.description,
    required this.employeesID,
    required this.employees,
    required this.currency,
    required this.isMobileService,
    required this.startAt,
    required this.category,
    required this.model,
    required this.type,
    required this.price,
    required this.listOfReviews,
    required this.time,
    required this.createdAt,
    required this.attachments,
    required this.excluded,
    required this.included,
  }) : inHiveAt = DateTime.now();

  @HiveField(0)
  final String businessID;
  @HiveField(1)
  final String serviceID;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final List<String> employeesID;
  @HiveField(4)
  final List<BusinessEmployeeEntity> employees;
  @HiveField(5)
  final String currency;
  @HiveField(6)
  final bool isMobileService;
  @HiveField(7)
  final bool startAt;
  @HiveField(8)
  final String category;
  @HiveField(9)
  final String model;
  @HiveField(10)
  final String type;
  @HiveField(11)
  final double price;
  @HiveField(12)
  final List<double> listOfReviews;
  @HiveField(13)
  final int time;
  @HiveField(14)
  final DateTime createdAt;
  @HiveField(15, defaultValue: <AttachmentEntity>[])
  final List<AttachmentEntity> attachments;
  @HiveField(16)
  final DateTime inHiveAt;
  @HiveField(17)
  final String excluded;
  @HiveField(18)
  final String? included;
  @HiveField(99)
  final String description;

  String? get thumbnailURL =>
      attachments.isEmpty ? null : attachments.first.url;
  String get priceStr =>
      '${CountryHelper.currencySymbolHelper(currency)}$price'.toUpperCase();

  Future<double?> getLocalPrice(GetExchangeRateUsecase usecase) async {
    final String fromCurrency = currency;
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
    // No fallback - return null if currency conversion fails
    return null;
  }

  // final List<ServiceReport> serviceReports;
}
