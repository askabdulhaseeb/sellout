import 'dart:convert';

import '../../../domain/entities/checkout/check_out_entity.dart';
import 'check_out_item_model.dart';

class CheckOutModel extends CheckOutEntity {
  CheckOutModel({
    required super.items,
    super.grandTotal = 0,
    super.currency = 'USD',
  });

  factory CheckOutModel.fromRawJson(String str) =>
      CheckOutModel.fromJson(json.decode(str));

  factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
        items: List<CheckOutItemModel>.from((json['items'] ?? <dynamic>[])
            .map((dynamic x) => CheckOutItemModel.fromJson(x))),
        grandTotal:
            double.tryParse(json['grandTotal']?.toString() ?? '0.0') ?? 0,
        currency: json['currency'] ?? '',
      );
}
