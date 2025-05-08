enum VehicleBodyType {
  sedan('Sedan', 'sedan'),
  hatchback('Hatchback', 'hatchback'),
  suv('SUV', 'suv'),
  coupe('Coupe', 'coupe'),
  convertible('Convertible', 'convertible'),
  wagon('Wagon', 'wagon'),
  van('Van', 'van'),
  minivan('Minivan', 'minivan'),
  pickupTruck('Pickup Truck', 'pickup_truck'),
  sportsCar('Sports Car', 'sports_car'),
  luxuryCar('Luxury Car', 'luxury_car'),
  crossover('Crossover', 'crossover'),
  hybridElectric('Hybrid/Electric', 'hybrid_electric'),
  commercialVehicle('Commercial Vehicle', 'commercial_vehicle'),
  limousine('Limousine', 'limousine'),
  roadster('Roadster', 'roadster'),
  microcar('Microcar', 'microcar'),
  bus('Bus', 'bus'),
  truck('Truck', 'truck'),

  // Bikes
  roadBike('Road Bike', 'road_bike'),
  mountainBike('Mountain Bike', 'mountain_bike'),
  hybridBike('Hybrid Bike', 'hybrid_bike'),
  touringBike('Touring Bike', 'touring_bike'),
  electricBike('Electric Bike', 'electric_bike'),
  bmx('BMX', 'bmx'),
  foldingBike('Folding Bike', 'folding_bike'),
  recumbentBike('Recumbent Bike', 'recumbent_bike'),
  cargoBike('Cargo Bike', 'cargo_bike'),
  fatBike('Fat Bike', 'fat_bike'),

  // Other
  other('Other', 'other');

  const VehicleBodyType(this.code, this.json);
  final String json;
  final String code;

  static List<VehicleBodyType> get all => VehicleBodyType.values;

  static VehicleBodyType fromJson(String? json) {
    return VehicleBodyType.all.firstWhere(
      (VehicleBodyType e) => e.json == json,
      orElse: () => VehicleBodyType.sedan,
    );
  }
}
