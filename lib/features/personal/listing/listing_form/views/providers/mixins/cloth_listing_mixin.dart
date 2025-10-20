import 'package:flutter/material.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../post/data/models/size_color/size_color_model.dart';
import '../../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../form_state/add_listing_form_state.dart';

mixin ClothListingMixin on ChangeNotifier {
  // The state will be provided by the class implementing this mixin
  AddListingFormState get state;

  // Getters that use the state
  String? get brand => state.brand;
  String get selectedClothSubType =>
      state.clothSubCategory ?? ListingType.clothAndFoot.cids.first;
  List<SizeColorEntity> get sizeColorEntities => state.sizeColorEntities;

  // Setters that update the state
  void setBrand(String? value) {
    state.brand = value;
    notifyListeners();
  }

  void setSelectedClothSubCategory(String value) {
    state.clothSubCategory = value;
    state.selectedCategory = null;
    notifyListeners();
  }

  void addOrUpdateSizeColorQuantity({
    required String size,
    required ColorOptionEntity color,
    required int quantity,
  }) {
    final int sizeIndex = state.sizeColorEntities
        .indexWhere((SizeColorEntity e) => e.value == size);

    if (sizeIndex != -1) {
      final SizeColorEntity existingSize = state.sizeColorEntities[sizeIndex];
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
      state.sizeColorEntities.add(
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
    final int sizeIndex = state.sizeColorEntities
        .indexWhere((SizeColorEntity e) => e.value == size);
    if (sizeIndex != -1) {
      state.sizeColorEntities[sizeIndex].colors
          .removeWhere((ColorEntity c) => c.code == color);
      if (state.sizeColorEntities[sizeIndex].colors.isEmpty) {
        state.sizeColorEntities.removeAt(sizeIndex);
      }
      notifyListeners();
    }
  }
}
