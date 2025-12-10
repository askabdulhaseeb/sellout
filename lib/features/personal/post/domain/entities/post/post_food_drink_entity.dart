import 'package:hive_ce/hive.dart';
part 'post_food_drink_entity.g.dart';

@HiveType(typeId: 72)
class PostFoodDrinkEntity {
  PostFoodDrinkEntity({required this.type, required this.address});

  @HiveField(0)
  final String type;

  @HiveField(1)
  final String? address;
}
