import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/utilities/app_images.dart';

enum CategoryTypes {
  clothandfootwear('cloth_foot'),
  foodanddrink('food_drink'),
  property('property'),
  vehicles('vehicles'),
  pets('pets');

  final String key;
  const CategoryTypes(this.key);
}

class CategoryType {
  CategoryType({
    this.category,
    required this.name,
    required this.imageUrl,
  });
  final CategoryTypes? category;
  final String name;
  final String imageUrl;

  String get displayName {
    return category?.translatedName ?? name.tr();
  }
}

extension CategoryTypesExtension on CategoryTypes {
  String get translatedName {
    return key.tr();
  }
}

final List<CategoryType> categories = <CategoryType>[
  CategoryType(
    category: null, // No category enum for 'popular'
    name: 'popular',
    imageUrl: AppImages.popularexplore,
  ),
  CategoryType(
    category: CategoryTypes.clothandfootwear,
    name: 'cloth_foot',
    imageUrl: AppImages.clothesandfootwearexplore,
  ),
  CategoryType(
    category: CategoryTypes.foodanddrink,
    name: 'food_drink',
    imageUrl: AppImages.foodanddrinkexplore,
  ),
  CategoryType(
    category: CategoryTypes.property,
    name: 'property',
    imageUrl: AppImages.propertyexplore,
  ),
  // Vehicles
  CategoryType(
    category: CategoryTypes.vehicles,
    name: 'vehicles',
    imageUrl: AppImages.vehicelexplore,
  ),
  CategoryType(
      category: CategoryTypes.pets,
      name: 'pets',
      imageUrl: AppImages.petsexplore),
];
