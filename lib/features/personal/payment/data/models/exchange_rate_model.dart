import '../../domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  const ExchangeRateModel({
    required super.rate,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      rate: double.tryParse(json['rate']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}
