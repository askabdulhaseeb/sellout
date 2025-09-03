import 'package:hive/hive.dart';
part 'post_pet_entity.g.dart';

@HiveType(typeId: 70)
class PostPetEntity {
  PostPetEntity({
    this.age,
    this.breed,
    this.healthChecked,
    this.petsCategory,
    this.readyToLeave,
    this.wormAndFleaTreated,
    this.vaccinationUpToDate,
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
}
