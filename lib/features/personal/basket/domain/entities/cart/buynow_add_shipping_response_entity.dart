import 'added_shipping_response_entity.dart';

class BuyNowAddShippingResponseEntity {
  const BuyNowAddShippingResponseEntity({
    required this.message,
    required this.selectedShipping,
    required this.ratesKey,
  });

  final String message;
  final List<SelectedShippingEntity> selectedShipping;
  final String ratesKey;
}
