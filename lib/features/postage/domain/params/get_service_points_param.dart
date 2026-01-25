/// Parameters for getting service points
class GetServicePointsParam {
  final List<String> cartItemIds;
  final String postalCode;
  final String carrier;
  final int radius;

  GetServicePointsParam({
    required this.cartItemIds,
    required this.postalCode,
    required this.carrier,
    this.radius = 1000,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'cart_item_ids': cartItemIds,
    'postal_code': postalCode,
    'carrier': carrier,
    'radius': radius,
  };
}
