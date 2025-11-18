import '../../../domain/entities/post/post_pet_entity.dart';

class PostPetModel extends PostPetEntity {
  PostPetModel({
    required super.age,
    required super.breed,
    required super.healthChecked,
    required super.petsCategory,
    required super.readyToLeave,
    required super.wormAndFleaTreated,
    required super.vaccinationUpToDate,
    required super.address,
  });

  factory PostPetModel.fromJson(Map<String, dynamic> json) {
    return PostPetModel(
      age: json['age']?.toString(),
      breed: json['breed']?.toString(),
      healthChecked: json['health_checked'] ?? false,
      petsCategory: json['pets_category']?.toString(),
      readyToLeave: json['ready_to_leave']?.toString(),
      wormAndFleaTreated: json['worm_and_flea_treated'] ?? false,
      vaccinationUpToDate: json['vaccination_up_to_date'] ?? false,
      address: json['address']?.toString() ?? '',
    );
  }

  // Map representation for request params (values as strings)
  Map<String, String> toParamMap() => <String, String>{
        'age': age?.toString() ?? '',
        'ready_to_leave': readyToLeave?.toString() ?? '',
        'breed': breed?.toString() ?? '',
        'health_checked': (healthChecked ?? false).toString(),
        'vaccination_up_to_date': (vaccinationUpToDate ?? false).toString(),
        'worm_and_flea_treated': (wormAndFleaTreated ?? false).toString(),
        'pets_category': petsCategory?.toString() ?? '',
        'address': address,
      };
}
