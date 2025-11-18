import 'package:hive/hive.dart';
part 'post_pet_entity.g.dart';

@HiveType(typeId: 70)
class PostPetEntity {
  PostPetEntity({
      required   this.age,
      required   this.breed,
      required   this.healthChecked,
      required   this.petsCategory,
      required   this.readyToLeave,
      required   this.wormAndFleaTreated,
      required   this.vaccinationUpToDate,
      required   this.address
  });

  @HiveField(0)
  final String? age;

  @HiveField(1)
  final String? breed;

  @HiveField(2)
  final bool? healthChecked;

  @HiveField(3)
  final String? petsCategory;

  @HiveField(4)
  final String? readyToLeave;

  @HiveField(5)
  final bool? wormAndFleaTreated;

  @HiveField(6)
  final bool? vaccinationUpToDate;

  @HiveField(7)
  final String address;
}
