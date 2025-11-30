import 'dart:convert';
import '../../../auth/signin/data/models/address_model.dart';
import '../../../auth/signin/domain/entities/address_entity.dart';

class GetPostageDetailParam {
  const GetPostageDetailParam({
    required this.buyerAddress,
    required this.fastDelivery,
  });

  final AddressEntity buyerAddress;
  final List<String> fastDelivery;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'buyer_address': AddressModel.fromEntity(buyerAddress).toShippingJson(),
        'fast_delivery': fastDelivery,
      };

  String toJson() => json.encode(toMap());
}
