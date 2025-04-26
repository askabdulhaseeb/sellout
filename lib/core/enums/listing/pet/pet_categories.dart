// enum PetCategory {
//    dogs('Dogs', 'dogs'),
//   cats('Cats', 'cats'),
//   birds('Birds', 'birds'),
//   fish('Fish', 'fish'),
//   horsesAndPonies('Horses and Ponies', 'horses_and_ponies'),
//   rabbits('Rabbits', 'rabbits'),
//   guineaPigs('Guinea Pigs', 'guinea_pigs'),
//   ferrets('Ferrets', 'ferrets'),
//   hamsters('Hamsters', 'hamsters'),
//   degusAndChinchillas('Degus and Chinchillas', 'degus_and_chinchillas'),
//   rats('Rats', 'rats'),
//   gerbils('Gerbils', 'gerbils'),
//   mice('Mice', 'mice'),
//   sugarGliders('Sugar Gliders', 'sugar_gilders'),
//   reptiles('Reptiles', 'reptiles'),
//   dogsSupplies('Dog Supplies', 'dogs_supplies'),
//   petBedsAndBedding('Pet Beds and Bedding', 'pet_beds_and_bedding'),
//   catsSupplies('Cat Supplies', 'cats_supplies'),
//   petCarrierAndContainment(
//       'Pet Carrier and Containment', 'pet_carrier_and_containment'),
//   birdsSupplies('Bird Supplies', 'birds_supplies'),
//   petCollarsAndLeads('Pet Collars and Leads', 'pet_collars_and_leads'),
//   fishSupplies('Fish Supplies', 'fish_supplies'),
//   petFeedingAndWatering(
//       'Pet Feeding and Watering Supplies', 'pet_feeding_and_watering_supplies'),
//   petGroomingSupplies('Pet Grooming Supplies', 'pet_grooming_supplies'),
//   petStepsAndRamps('Pet Steps and Ramps', 'pet_steps_and_ramps'),
//   reptilesAndAmphibiansSupplies(
//       'Reptiles and Amphibians Supplies', 'reptiles_and_amphibians_supplies'),
//   smallAnimalSupplies('Small Animal Supplies', 'small_animal_supplies'),
//   equipmentAndAccessories(
//       'Equipment and Accessories', 'equipment_and_accessories'),
//   missingLostAndFound('Missing, Lost and Found', 'missing_lost_and_found');

//   const PetCategory(this.title, this.json);
//   final String title;
//   final String json;

//   static PetCategory? fromJson(String? json) {
//     if (json == null) return null;
//     return PetCategory.values.firstWhere(
//       (PetCategory e) => e.json == json,
//       orElse: () => PetCategory.dogs,
//     );
//   }

//   String toJson() => json;

//   @override
//   String toString() => json;

//   static List<PetCategory> get valuesList => PetCategory.values;
// }
