/// Parameters for getting service points
class GetServicePointsParam {
<<<<<<< HEAD
  final List<String> cartItemIds;
  final String postalCode;
  final String carrier;
  final int radius;
=======
>>>>>>> e947def20999a92448313553bb695b63691bc934

  GetServicePointsParam({
    required this.cartItemIds,
    required this.postalCode,
    required this.carrier,
    this.radius = 1000,
  });
<<<<<<< HEAD
=======
  final List<String> cartItemIds;
  final String postalCode;
  final String carrier;
  final int radius;
>>>>>>> e947def20999a92448313553bb695b63691bc934

  Map<String, dynamic> toJson() => <String, dynamic>{
    'cart_item_ids': cartItemIds,
    'postal_code': postalCode,
    'carrier': carrier,
    'radius': radius,
  };
}
