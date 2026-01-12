import 'dart:convert';
import '../../../../auth/signin/data/models/address_model.dart';

class OfferPaymentResponse {

  factory OfferPaymentResponse.fromJson(Map<String, dynamic> json) {
    final dynamic buyerAddressRaw = json['buyer_address'];
    Map<String, dynamic> buyerAddressMap = <String, dynamic>{};
    if (buyerAddressRaw is Map<String, dynamic>) {
      buyerAddressMap = buyerAddressRaw;
    } else if (buyerAddressRaw is String && buyerAddressRaw.trim().isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(buyerAddressRaw);
        if (decoded is Map) {
          buyerAddressMap = decoded.cast<String, dynamic>();
        }
      } catch (_) {}
    }

    return OfferPaymentResponse(
      offerId: json['offer_id']?.toString() ?? '',
      buyerAddress: AddressModel.fromJson(buyerAddressMap),
      clientSecret:
          json['clientSecret']?.toString() ?? json['client_secret']?.toString(),
    );
  }
  OfferPaymentResponse({
    required this.offerId,
    required this.buyerAddress,
    this.clientSecret,
  });

  final String offerId;
  final AddressModel buyerAddress;
  final String? clientSecret;
}
