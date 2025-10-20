import 'package:easy_localization/easy_localization.dart';

enum DeliveryPayer {
  buyerPays(code: 'customer_pays', jsonKey: 'buyerPays'),
  sellerPays(code: 'seller_pays', jsonKey: 'sellerPays');

  const DeliveryPayer({required this.code, required this.jsonKey});

  final String code;
  final String jsonKey;

  static DeliveryPayer fromJson(String value) {
    return DeliveryPayer.values.firstWhere(
      (DeliveryPayer e) => e.jsonKey == value,
      orElse: () => DeliveryPayer.buyerPays,
    );
  }

  String toJson() => jsonKey;

  String get localized => code.tr();
}
