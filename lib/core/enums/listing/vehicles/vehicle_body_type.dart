enum VehicleBodyType {
  car('car', 'car'),
  motorbike('motor_bike', 'motor_bike'),
  watercraft('water_craft', 'water_craft'),
  van('van', 'van'),
  bus('bus', 'bus'),
  lorry('lorry', 'lorry'),
  quadBike('quad_bike', 'quadbike_buggy'),
  threeWheeler('3_wheeler', '3_wheeler'),
  taxi('taxi', 'taxi'),
  rv('rv_campervan', 'rv_campervan');

  const VehicleBodyType(this.json, this.code);
  final String json;
  final String code;

  static List<VehicleBodyType> get all => VehicleBodyType.values;

  static VehicleBodyType fromJson(String json) {
    return VehicleBodyType.all
        .firstWhere((VehicleBodyType e) => e.json == json);
  }
}
