import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../../../core/theme/app_theme.dart';

part 'counter_offer_enum.g.dart';

@HiveType(typeId: 67)
enum CounterOfferEnum {
  @HiveField(0)
  seller('offer_given_by_seller', AppTheme.primaryColor, 'seller'),

  @HiveField(1)
  buyer('offer_given_by_buyer', AppTheme.secondaryColor, 'buyer');

  const CounterOfferEnum(this.code, this.color, this.json);

  final String code;
  final Color color;
  final String json;

  String toApiValue() => json;

  static CounterOfferEnum? fromMap(String? apiValue) {
    if (apiValue == null) return null;
    try {
      return CounterOfferEnum.values.firstWhere(
        (CounterOfferEnum e) => e.json.toLowerCase() == apiValue.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
