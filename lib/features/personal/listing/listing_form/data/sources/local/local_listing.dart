import 'package:hive/hive.dart';

import '../../../../../../../core/utilities/app_string.dart';
import '../../../domain/entities/listing_entity.dart';

class LocalListing {
  static final String boxTitle = AppStrings.localListingBox;
  static Box<ListingEntity> get _box => Hive.box<ListingEntity>(boxTitle);

  static Future<Box<ListingEntity>> get openBox async =>
      await Hive.openBox<ListingEntity>(boxTitle);

  Future<Box<ListingEntity>> refresh() async {
    final bool isOpen = Hive.isBoxOpen(boxTitle);
    if (isOpen) {
      return _box;
    } else {
      return await Hive.openBox<ListingEntity>(boxTitle);
    }
  }

  Future<void> save(ListingEntity value) async =>
      await _box.put(value.listId, value);

  Future<void> clear() async => await _box.clear();

  ListingEntity? listingEntity(String value) => _box.get(value);

  List<ListingEntity> get listings =>
      _box.values.where((ListingEntity element) => element.isActive).toList();
}
