import '../../../../../../core/enums/listing/core/delivery_type.dart';
import '../../../../../../core/enums/listing/core/item_condition_type.dart';
import '../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../marketplace/domain/params/filter_params.dart';
import 'base_profile_posts_provider.dart';

class ProfileStorePostsProvider extends BaseProfilePostsProvider {
  ProfileStorePostsProvider(super.usecase, {super.userUid});

  ConditionType? _selectedConditionType;
  DeliveryType? _selectedDeliveryType;

  ConditionType? get selectedConditionType => _selectedConditionType;
  DeliveryType? get selectedDeliveryType => _selectedDeliveryType;

  @override
  String get providerName => 'ProfileStorePostsProvider';

  @override
  List<ListingType> get listingTypes => ListingType.storeList;

  @override
  List<FilterParam> get additionalFilters {
    final List<FilterParam> filters = <FilterParam>[];

    if (_selectedConditionType != null) {
      filters.add(
        FilterParam(
          attribute: 'item_condition',
          operator: 'eq',
          value: _selectedConditionType?.json ?? '',
        ),
      );
    }

    if (_selectedDeliveryType != null) {
      filters.add(
        FilterParam(
          attribute: 'delivery_type',
          operator: 'eq',
          value: _selectedDeliveryType?.json ?? '',
        ),
      );
    }

    return filters;
  }

  @override
  void resetAdditionalFilters() {
    _selectedConditionType = null;
    _selectedDeliveryType = null;
    notifyListeners();
  }

  void setConditionType(ConditionType? value) {
    _selectedConditionType = value;
    notifyListeners();
  }

  void setDeliveryType(DeliveryType? value) {
    _selectedDeliveryType = value;
    notifyListeners();
  }
}
