import 'package:flutter/material.dart';

import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../post/data/models/size_color/size_color_model.dart';
import '../../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../domain/entities/color_options_entity.dart';

mixin ClothListingMixin on ChangeNotifier {
  String? _brand;
  String _selectedClothSubCategory = ListingType.clothAndFoot.cids.first;
  List<SizeColorEntity> _sizeColorEntities = <SizeColorEntity>[];

  // Getters
  String? get brand => _brand;
  String get selectedClothSubCategory => _selectedClothSubCategory;
  List<SizeColorEntity> get sizeColorEntities => _sizeColorEntities;

  // Setters
  void setBrand(String? value) {
    _brand = value;
    notifyListeners();
  }

  void setSelectedClothSubCategory(String value) {
    _selectedClothSubCategory = value;
    notifyListeners();
  }

  void addOrUpdateSizeColorQuantity({
    required String size,
    required ColorOptionEntity color,
    required int quantity,
  }) {
    final int sizeIndex =
        _sizeColorEntities.indexWhere((SizeColorEntity e) => e.value == size);

    if (sizeIndex != -1) {
      final SizeColorEntity existingSize = _sizeColorEntities[sizeIndex];
      final int colorIndex = existingSize.colors
          .indexWhere((ColorEntity c) => c.code == color.value);

      if (colorIndex != -1) {
        existingSize.colors[colorIndex] =
            ColorEntity(code: color.value, quantity: quantity);
      } else {
        existingSize.colors
            .add(ColorEntity(code: color.value, quantity: quantity));
      }
    } else {
      _sizeColorEntities.add(
        SizeColorModel(
          value: size,
          id: size,
          colors: <ColorEntity>[
            ColorEntity(code: color.value, quantity: quantity)
          ],
        ),
      );
    }
    notifyListeners();
  }

  void removeColorFromSize({required String size, required String color}) {
    final int sizeIndex =
        _sizeColorEntities.indexWhere((SizeColorEntity e) => e.value == size);
    if (sizeIndex != -1) {
      _sizeColorEntities[sizeIndex]
          .colors
          .removeWhere((ColorEntity c) => c.code == color);
      if (_sizeColorEntities[sizeIndex].colors.isEmpty) {
        _sizeColorEntities.removeAt(sizeIndex);
      }
      notifyListeners();
    }
  }
}
