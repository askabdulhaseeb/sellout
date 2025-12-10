import 'package:hive_ce/hive.dart';
import '../../../../../../../core/sources/local/local_hive_box.dart';
import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/listing_entity.dart';
import '../../models/sub_category_model.dart';

class LocalListing extends LocalHiveBox<ListingEntity> {
  @override
  String get boxName => AppStrings.localListingBox;

  Box<ListingEntity> get _box => box;
  ListingEntity? listingEntity(String value) => _box.get(value);

  List<ListingEntity> get listings =>
      _box.values.where((ListingEntity element) => element.isActive).toList();

  SubCategoryEntity? _findInSubCategories(
    List<SubCategoryEntity> list,
    String address,
  ) {
    for (final SubCategoryEntity subCat in list) {
      if (subCat.address == address) return subCat;
      if (subCat.subCategory.isNotEmpty) {
        final SubCategoryEntity? found = _findInSubCategories(
          subCat.subCategory,
          address,
        );
        if (found != null) return found;
      }
    }
    return null;
  }

  SubCategoryEntity? getSubCategoryByAddress(String address) {
    for (final ListingEntity listing in _box.values) {
      final SubCategoryEntity? found = _findInSubCategories(
        listing.subCategory,
        address,
      );
      if (found != null) return found;
    }
    return null;
  }
}
