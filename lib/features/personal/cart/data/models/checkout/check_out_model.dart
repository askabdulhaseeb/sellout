import 'dart:convert';

import '../../../../auth/signin/data/models/address_model.dart';
import '../../../domain/entities/checkout/check_out_entity.dart';
import 'check_out_item_model.dart';

class CheckOutModel extends CheckOutEntity {
  CheckOutModel({
    required super.items,
    super.grandTotal = 0,
    super.currency = 'USD',
    super.buyerId = '',
    super.buyerAddress,
  });

  factory CheckOutModel.fromRawJson(String str) =>
      CheckOutModel.fromJson(json.decode(str));
  factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
        items: List<CheckOutItemModel>.from((json['items'] ?? <dynamic>[])
            .map((dynamic x) => CheckOutItemModel.fromJson(x))),
        grandTotal:
            double.tryParse(json['grandTotal']?.toString() ?? '0.0') ?? 0,
        currency: json['currency'] ?? '',
        buyerId: json['buyer_id'] ?? '',
        buyerAddress: json['buyer_address'] != null
            ? AddressModel.fromJson(json['buyer_address'])
            : null,
      );
}
