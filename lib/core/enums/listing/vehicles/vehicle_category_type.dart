enum VehicleCategoryType {
  cars('Cars', 'cars'),
  vanAndLorries('Van and Lorries', 'van_and_lorries'),
  motorcycle('Motorcycle', 'motorcycle'),
  powerSports('Power Sports', 'power_sports'),
  motorhomesAndCampers('Motorhomes and Campers', 'motorhomes_and_campers'),
  boats('Boats', 'boats'),
  commercialAndIndustrial(
      'Commercial and Industrial', 'commercial_and_industrial'),
  trailers('Trailers', 'trailers'),
  sportsCar('Sports Car', 'sports_car'),
  others('Others', 'others');

  const VehicleCategoryType(this.label, this.json);
  final String label;
  final String json;
  static VehicleCategoryType? fromJson(String? json) {
    if (json == null) return null;
    for (final VehicleCategoryType item in VehicleCategoryType.values) {
      if (item.json == json) return item;
    }
    return null;
  }
}
