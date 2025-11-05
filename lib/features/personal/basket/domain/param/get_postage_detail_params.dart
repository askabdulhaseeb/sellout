import 'dart:convert';
import '../../../auth/signin/data/models/address_model.dart';

class GetPostageDetailParam {
  const GetPostageDetailParam({
    required this.buyerAddress,
    required this.fastDelivery,
  });

  final AddressModel buyerAddress;
  final List<String> fastDelivery;

  Map<String, dynamic> toMap() => {
        'buyer_address': buyerAddress.toCheckoutJson(),
        'fast_delivery': fastDelivery,
      };

  String toJson() => json.encode(toMap());
}
